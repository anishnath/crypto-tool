<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "control-if");
   request.setAttribute("currentModule", "Control Flow"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Bash If Statements - Conditional Logic, if-else-elif | 8gwifi.org</title>
    <meta name="description"
        content="Learn Bash if statements: if-then-elif-else-fi syntax, single-line if, nested if statements, and conditional logic in shell scripts.">
    <meta name="keywords"
        content="bash if statement, bash if else, bash conditional, bash elif, bash nested if, shell scripting conditionals">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Bash If Statements - Conditional Logic, if-else-elif">
    <meta property="og:description" content="Master Bash if statements for conditional logic in your shell scripts.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/control-if.jsp">
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
        "name": "Bash If Statements",
        "description": "Learn Bash if statements: if-then-elif-else-fi syntax, single-line if, and nested conditionals.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["If statement syntax", "if-else statements", "elif clause", "Nested if statements", "Single-line if", "Conditional logic"],
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

<body class="tutorial-body no-preview" data-lesson="control-if">
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
                    <span>If Statements</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">If Statements</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">If statements allow your scripts to make decisions based on conditions. They're the foundation of conditional logic in Bash, enabling your scripts to respond differently based on values, file states, command results, and more. Understanding if statements is essential for writing dynamic, responsive shell scripts!</p>

                    <!-- Section 1: Basic If Statement -->
                    <h2>Basic If Statement</h2>
                    <p>The simplest form of an if statement executes code only when a condition is true. The syntax uses <code>if</code>, <code>then</code>, and <code>fi</code> (if backwards).</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/control-if.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-if-basics" />
                    </jsp:include>

                    <pre><code class="language-bash"># Basic syntax
if [ condition ]; then
    # code to execute if condition is true
fi

# Example
age=18
if [ $age -ge 18 ]; then
    echo "You are an adult"
fi</code></pre>

                    <div class="info-box">
                        <strong>Syntax Notes:</strong><br>
                        - Spaces around brackets are required: <code>[ condition ]</code><br>
                        - <code>then</code> must be on same line with <code>;</code> or on next line<br>
                        - <code>fi</code> closes the if statement (if spelled backwards)<br>
                        - The condition uses test operators (covered in Operators module)
                    </div>

                    <!-- Section 2: If-Else Statement -->
                    <h2>If-Else Statement</h2>
                    <p>When you want to handle both true and false cases, use <code>else</code> to specify what happens when the condition is false.</p>

                    <pre><code class="language-bash">if [ condition ]; then
    # code if true
else
    # code if false
fi

# Example
age=15
if [ $age -ge 18 ]; then
    echo "You are an adult"
else
    echo "You are a minor"
fi</code></pre>

                    <!-- Section 3: If-Elif-Else Statement -->
                    <h2>If-Elif-Else Statement</h2>
                    <p>For multiple conditions, use <code>elif</code> (else if) to chain conditions. Bash checks conditions in order and executes the first one that's true.</p>

                    <pre><code class="language-bash">if [ condition1 ]; then
    # code if condition1 is true
elif [ condition2 ]; then
    # code if condition2 is true
elif [ condition3 ]; then
    # code if condition3 is true
else
    # code if all conditions are false
fi

# Example: Grade calculation
score=85
if [ $score -ge 90 ]; then
    grade="A"
elif [ $score -ge 80 ]; then
    grade="B"
elif [ $score -ge 70 ]; then
    grade="C"
else
    grade="F"
fi</code></pre>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> The order of <code>elif</code> conditions matters! Bash stops checking once it finds a true condition. Place more specific conditions first and broader ones later.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 4: Single-Line If -->
                    <h2>Single-Line If Statement</h2>
                    <p>For simple conditions, you can write if statements on a single line. This is useful for quick checks and is common in shell scripts.</p>

                    <pre><code class="language-bash"># Single-line if
if [ condition ]; then command; fi

# Using && and || operators
[ condition ] && command_if_true || command_if_false

# Examples
[ -f file.txt ] && echo "File exists"
[ $age -ge 18 ] && echo "Adult" || echo "Minor"

# Common pattern
[ -d "/tmp" ] && rm -rf /tmp/* || echo "Directory not found"</code></pre>

                    <div class="warning-box">
                        <strong>Caution:</strong> Single-line if statements with <code>&&</code> and <code>||</code> can be confusing. The <code>||</code> part executes if the command fails, which might not always be what you expect. Use multi-line if statements for clarity when logic is complex!
                    </div>

                    <!-- Section 5: Nested If Statements -->
                    <h2>Nested If Statements</h2>
                    <p>You can place if statements inside other if statements to create complex conditional logic. Each nested if needs its own <code>fi</code>.</p>

                    <pre><code class="language-bash"># Nested if example
age=25
if [ $age -ge 18 ]; then
    echo "Adult"
    if [ $age -ge 65 ]; then
        echo "Senior citizen"
    else
        echo "Regular adult"
    fi
else
    echo "Minor"
fi</code></pre>

                    <div class="info-box">
                        <strong>Nesting Tips:</strong><br>
                        - Each <code>if</code> must have a matching <code>fi</code><br>
        - Proper indentation makes nested ifs readable<br>
        - Consider using <code>elif</code> instead of nested ifs when possible (often clearer)
                    </div>

                    <!-- Section 6: Advanced If with [[ ]] -->
                    <h2>Advanced: Using [[ ]] Instead of [ ]</h2>
                    <p>Bash provides two ways to test conditions: <code>[ ]</code> (POSIX compatible) and <code>[[ ]]</code> (Bash-specific, more powerful).</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/control-if-advanced.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-if-advanced" />
                    </jsp:include>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Feature</th>
                                <th>[ ] (test)</th>
                                <th>[[ ]] (Bash)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Pattern matching</td>
                                <td>No</td>
                                <td>Yes (<code>[[ $var == *.txt ]]</code>)</td>
                            </tr>
                            <tr>
                                <td>Regex matching</td>
                                <td>No</td>
                                <td>Yes (<code>[[ $var =~ regex ]]</code>)</td>
                            </tr>
                            <tr>
                                <td>Logical operators</td>
                                <td><code>-a</code>, <code>-o</code></td>
                                <td><code>&&</code>, <code>||</code></td>
                            </tr>
                            <tr>
                                <td>Variable handling</td>
                                <td>Quotes needed</td>
                                <td>Safer without quotes</td>
                            </tr>
                            <tr>
                                <td>Portability</td>
                                <td>POSIX standard</td>
                                <td>Bash-specific</td>
                            </tr>
                        </tbody>
                    </table>

                    <pre><code class="language-bash"># [[ ]] advantages
filename="test.txt"

# Pattern matching
if [[ $filename == *.txt ]]; then
    echo "Text file"
fi

# Regex matching
if [[ $email =~ ^[a-zA-Z0-9._%+-]+@ ]]; then
    echo "Valid email"
fi

# Logical operators
if [[ -f "$file" && -r "$file" ]]; then
    echo "File exists and is readable"
fi</code></pre>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Missing spaces around brackets</h4>
                        <pre><code class="language-bash"># Wrong - no spaces
if [$age -ge 18]; then  # Syntax error!

# Correct - spaces required
if [ $age -ge 18 ]; then
    echo "Adult"
fi</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Using = instead of -eq for numbers</h4>
                        <pre><code class="language-bash"># Wrong - = compares strings
if [ $count = 5 ]; then  # Works but string comparison

# Correct - -eq for numeric comparison
if [ $count -eq 5 ]; then  # Proper numeric comparison

# For strings, = is correct
if [ "$name" = "Alice" ]; then  # String comparison</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Forgetting then on new line</h4>
                        <pre><code class="language-bash"># Wrong - missing semicolon
if [ condition ]
then  # Error if then is on next line without proper syntax

# Correct - semicolon or then on same line
if [ condition ]; then
    command
fi

# Or then on next line (needs proper formatting)
if [ condition ]
then
    command
fi</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Using assignment in condition</h4>
                        <pre><code class="language-bash"># Wrong - assignment, not comparison
if [ $count = 5 ]; then  # Actually assigns (in some contexts)

# Correct - use == or -eq
if [ $count -eq 5 ]; then  # Comparison
if [[ $count == 5 ]]; then  # Comparison

# For string comparison
if [ "$name" = "Alice" ]; then  # String comparison (single =)
if [[ "$name" == "Alice" ]]; then  # String comparison (==)</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Create a Decision Script</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a script that makes decisions based on conditions!</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Create a variable for age</li>
                            <li>Use if-elif-else to categorize: child (0-12), teenager (13-17), adult (18-64), senior (65+)</li>
                            <li>Check if a file exists and print appropriate message</li>
                            <li>Use nested if to check both age and a status variable</li>
                            <li>Include at least one single-line if statement</li>
                        </ul>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-bash">#!/bin/bash
# Decision script

age=25
status="active"

# Age categorization
if [ $age -le 12 ]; then
    category="child"
elif [ $age -le 17 ]; then
    category="teenager"
elif [ $age -le 64 ]; then
    category="adult"
else
    category="senior"
fi
echo "Age $age: $category"

# File check
[ -f /etc/passwd ] && echo "File exists" || echo "File not found"

# Nested if
if [ $age -ge 18 ]; then
    if [ "$status" = "active" ]; then
        echo "Active adult"
    else
        echo "Inactive adult"
    fi
fi</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Basic If:</strong> <code>if [ condition ]; then ... fi</code></li>
                            <li><strong>If-Else:</strong> <code>if ... else ... fi</code> handles true and false cases</li>
                            <li><strong>Elif:</strong> Chain multiple conditions with <code>elif</code></li>
                            <li><strong>Single-Line:</strong> <code>if [ cond ]; then cmd; fi</code> or <code>[ cond ] && cmd</code></li>
                            <li><strong>Nested:</strong> If statements can contain other if statements</li>
                            <li><strong>Spaces:</strong> Always use spaces around brackets: <code>[ condition ]</code></li>
                            <li><strong>[[ ]] vs [ ]:</strong> <code>[[ ]]</code> is Bash-specific and more powerful</li>
                            <li><strong>Operators:</strong> Use <code>-eq</code>, <code>-ne</code> for numbers; <code>=</code>, <code>!=</code> for strings</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Great job mastering if statements! Next, we'll learn about <strong>Case Statements</strong> - a cleaner alternative to long if-elif chains when checking a single variable against multiple values. Case statements are perfect for menu systems and command parsing!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="strings-heredoc.jsp" />
                    <jsp:param name="prevTitle" value="Here Documents" />
                    <jsp:param name="nextLink" value="control-case.jsp" />
                    <jsp:param name="nextTitle" value="Case Statements" />
                    <jsp:param name="currentLessonId" value="control-if" />
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

