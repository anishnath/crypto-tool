<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "control-case");
   request.setAttribute("currentModule", "Control Flow"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Bash Case Statements - Pattern Matching, Multiple Conditions | 8gwifi.org</title>
    <meta name="description"
        content="Learn Bash case statements: case-esac syntax, pattern matching with *, ?, [], and handling multiple conditions elegantly in shell scripts.">
    <meta name="keywords"
        content="bash case statement, bash case esac, bash pattern matching, bash switch statement, shell scripting case">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Bash Case Statements - Pattern Matching, Multiple Conditions">
    <meta property="og:description" content="Master Bash case statements for cleaner multi-way conditional logic.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/control-case.jsp">
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
        "name": "Bash Case Statements",
        "description": "Learn Bash case statements: case-esac syntax, pattern matching with wildcards, and handling multiple conditions.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Case statement syntax", "Pattern matching", "Wildcards * ?", "Character classes []", "Multiple patterns", "Default case"],
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

<body class="tutorial-body no-preview" data-lesson="control-case">
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
                    <span>Case Statements</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Case Statements</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~20 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Case statements provide a cleaner, more readable alternative to long if-elif chains when checking a single variable against multiple values. They're perfect for menu systems, command parsing, file type detection, and any situation where you need multi-way branching based on a single value. Case statements use pattern matching, making them more powerful than simple equality checks!</p>

                    <!-- Section 1: Basic Case Statement -->
                    <h2>Basic Case Statement Syntax</h2>
                    <p>A case statement starts with <code>case</code>, tests a value against patterns, and ends with <code>esac</code> (case spelled backwards). Each pattern is followed by <code>)</code> and ends with <code>;;</code>.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/control-case.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-case" />
                    </jsp:include>

                    <pre><code class="language-bash"># Basic syntax
case variable in
    pattern1)
        # code for pattern1
        ;;
    pattern2)
        # code for pattern2
        ;;
    *)
        # default case (optional)
        ;;
esac

# Example
choice="yes"
case $choice in
    yes|y|YES|Y)
        echo "You chose yes"
        ;;
    no|n|NO|N)
        echo "You chose no"
        ;;
    *)
        echo "Invalid choice"
        ;;
esac</code></pre>

                    <div class="info-box">
                        <strong>Key Points:</strong><br>
                        - <code>case</code> starts, <code>esac</code> ends (case backwards)<br>
                        - Each pattern ends with <code>)</code><br>
                        - Each case block ends with <code>;;</code> (double semicolon)<br>
                        - <code>*)</code> is the default case (matches anything)<br>
                        - Patterns use glob matching (not regex)
                    </div>

                    <!-- Section 2: Pattern Matching -->
                    <h2>Pattern Matching</h2>
                    <p>Case statements support glob patterns, making them powerful for matching multiple values and ranges.</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Pattern</th>
                                <th>Description</th>
                                <th>Example</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>*</code></td>
                                <td>Matches any string</td>
                                <td><code>*.txt</code> matches any .txt file</td>
                            </tr>
                            <tr>
                                <td><code>?</code></td>
                                <td>Matches any single character</td>
                                <td><code>file?.txt</code> matches file1.txt, fileA.txt</td>
                            </tr>
                            <tr>
                                <td><code>[]</code></td>
                                <td>Character class - matches one character from set</td>
                                <td><code>[0-9]</code> matches any digit</td>
                            </tr>
                            <tr>
                                <td><code>|</code></td>
                                <td>OR - matches if any pattern matches</td>
                                <td><code>yes|y|YES</code> matches any of these</td>
                            </tr>
                            <tr>
                                <td><code>*</code> (default)</td>
                                <td>Default case (match anything)</td>
                                <td><code>*)</code> catch-all case</td>
                            </tr>
                        </tbody>
                    </table>

                    <pre><code class="language-bash"># File extension check
filename="image.jpg"
case $filename in
    *.jpg|*.jpeg)
        echo "JPEG image"
        ;;
    *.png)
        echo "PNG image"
        ;;
    *.gif)
        echo "GIF image"
        ;;
    *)
        echo "Unknown file type"
        ;;
esac

# Character class example
char="a"
case $char in
    [a-z])
        echo "Lowercase letter"
        ;;
    [A-Z])
        echo "Uppercase letter"
        ;;
    [0-9])
        echo "Digit"
        ;;
    *)
        echo "Other character"
        ;;
esac</code></pre>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Multiple Patterns -->
                    <h2>Multiple Patterns</h2>
                    <p>You can combine multiple patterns using <code>|</code> (pipe) to match any of them. This is cleaner than separate if-elif conditions.</p>

                    <pre><code class="language-bash"># Multiple patterns with |
action="START"
case $action in
    start|START|begin|BEGIN)
        echo "Starting service..."
        ;;
    stop|STOP|halt|HALT)
        echo "Stopping service..."
        ;;
    restart|RESTART|reboot|REBOOT)
        echo "Restarting service..."
        ;;
    *)
        echo "Unknown action"
        ;;
esac</code></pre>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Case statements are much cleaner than long if-elif chains! Use case when checking a single variable against multiple values. Use if-elif when you need to check different variables or complex conditions.
                    </div>

                    <!-- Section 4: Practical Examples -->
                    <h2>Practical Examples</h2>
                    <p>Case statements are commonly used in real-world scripts:</p>

                    <pre><code class="language-bash"># Menu system
PS3="Choose an option: "
read choice
case $choice in
    1)
        echo "Starting..."
        ;;
    2)
        echo "Stopping..."
        ;;
    3)
        echo "Restarting..."
        ;;
    q|Q|quit|QUIT)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid option"
        ;;
esac

# Command parsing
command="$1"
case $command in
    install|i)
        echo "Installing..."
        ;;
    uninstall|remove|r)
        echo "Uninstalling..."
        ;;
    status|s)
        echo "Checking status..."
        ;;
    *)
        echo "Usage: script.sh [install|uninstall|status]"
        exit 1
        ;;
esac</code></pre>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Missing double semicolon (;;)</h4>
                        <pre><code class="language-bash"># Wrong - missing ;;
case $var in
    pattern1)
        echo "Matched"
    # Missing ;; causes fall-through!
    pattern2)
        echo "Also matches"
        ;;
esac

# Correct - each case ends with ;;
case $var in
    pattern1)
        echo "Matched"
        ;;  # Required!
    pattern2)
        echo "Also matches"
        ;;
esac</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Using == instead of pattern matching</h4>
                        <pre><code class="language-bash"># Wrong - == doesn't work in case
case $var in
    == "value")  # Syntax error
        echo "Match"
        ;;
esac

# Correct - just use the pattern
case $var in
    value)  # Matches exact string
        echo "Match"
        ;;
    "value with spaces")  # Quote if needed
        echo "Match"
        ;;
esac</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Confusing glob patterns with regex</h4>
                        <pre><code class="language-bash"># Case uses GLOB patterns, not regex
filename="test123.txt"

# Correct - glob patterns
case $filename in
    test*.txt)  # Matches test, then any chars, then .txt
        echo "Match"
        ;;
esac

# Wrong - regex syntax doesn't work
case $filename in
    test[0-9]+.txt)  # + doesn't work in glob
        echo "Won't match as expected"
        ;;
esac</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Create a File Type Detector</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a script that detects file types using case statements!</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Use a case statement to check file extension</li>
                            <li>Handle at least 4 different file types (e.g., images, documents, scripts)</li>
                            <li>Use pattern matching with wildcards</li>
                            <li>Include a default case for unknown types</li>
                            <li>Support multiple extensions for same type (e.g., jpg and jpeg)</li>
                        </ul>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-bash">#!/bin/bash
# File type detector

filename="$1"

case "$filename" in
    *.jpg|*.jpeg|*.JPG|*.JPEG)
        echo "$filename: JPEG image"
        ;;
    *.png|*.PNG)
        echo "$filename: PNG image"
        ;;
    *.sh|*.bash)
        echo "$filename: Shell script"
        ;;
    *.py)
        echo "$filename: Python script"
        ;;
    *.txt|*.md|*.log)
        echo "$filename: Text file"
        ;;
    *)
        echo "$filename: Unknown file type"
        ;;
esac</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Syntax:</strong> <code>case variable in pattern) ... ;; esac</code></li>
                            <li><strong>Patterns:</strong> Use glob patterns (*, ?, []) not regex</li>
                            <li><strong>Multiple:</strong> Combine patterns with <code>|</code> (pipe)</li>
                            <li><strong>Ending:</strong> Each case ends with <code>;;</code> (double semicolon)</li>
                            <li><strong>Default:</strong> Use <code>*)</code> for catch-all case</li>
                            <li><strong>Closing:</strong> End with <code>esac</code> (case backwards)</li>
                            <li><strong>Use When:</strong> Checking single variable against multiple values</li>
                            <li><strong>Advantage:</strong> Cleaner than long if-elif chains</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Excellent! Case statements make multi-way decisions much cleaner. Next, we'll dive into <strong>For Loops</strong> - one of the most commonly used control structures for iterating over lists, arrays, files, and ranges. You'll learn different for loop styles and when to use each!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="control-if.jsp" />
                    <jsp:param name="prevTitle" value="If Statements" />
                    <jsp:param name="nextLink" value="loops-for.jsp" />
                    <jsp:param name="nextTitle" value="For Loops" />
                    <jsp:param name="currentLessonId" value="control-case" />
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

