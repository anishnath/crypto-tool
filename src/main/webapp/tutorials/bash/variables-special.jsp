<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "variables-special");
   request.setAttribute("currentModule", "Variables & Environment"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Bash Special Variables - $0, $1-$9, $#, $@, $*, $$, $?, $! | 8gwifi.org</title>
    <meta name="description"
        content="Learn Bash special variables: $0 (script name), $1-$9 (arguments), $# (argument count), $@ and $* (all arguments), $$ (process ID), $? (exit status), and $! (background PID).">
    <meta name="keywords"
        content="bash special variables, bash arguments $1 $2, bash $#, bash $@, bash $$, bash $?, exit status, bash process ID, bash script arguments">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Bash Special Variables - $0, $1-$9, $#, $@, $*, $$, $?, $!">
    <meta property="og:description" content="Master Bash special variables for script arguments, process IDs, exit codes, and more.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/variables-special.jsp">
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
        "name": "Bash Special Variables",
        "description": "Learn Bash special variables: $0, $1-$9, $#, $@, $*, $$, $?, $!. Essential for command-line argument handling.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["$0 script name", "$1-$9 arguments", "$# argument count", "$@ and $* all arguments", "$$ process ID", "$? exit status", "$! background PID"],
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

<body class="tutorial-body no-preview" data-lesson="variables-special">
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
                    <span>Special Variables</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Special Variables</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~20 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Bash provides several special variables that are automatically set and contain useful information about the script execution context. These variables give you access to command-line arguments, the script name, process IDs, exit statuses, and more. Understanding special variables is essential for writing scripts that accept arguments and handle errors properly!</p>

                    <!-- Section 1: Script Name $0 -->
                    <h2>Script Name: $0</h2>
                    <p>The <code>$0</code> variable contains the name of the script or command being executed. This is useful for error messages, help text, and logging.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/variables-special.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-special" />
                    </jsp:include>

                    <pre><code class="language-bash">#!/bin/bash
# Display script name
echo "This script is called: $0"

# Practical use: help message
if [ $# -eq 0 ]; then
    echo "Usage: $0 &lt;filename&gt;"
    exit 1
fi</code></pre>

                    <!-- Section 2: Positional Parameters $1-$9 -->
                    <h2>Positional Parameters: $1, $2, ... $9</h2>
                    <p>These variables contain the command-line arguments passed to your script. <code>$1</code> is the first argument, <code>$2</code> is the second, and so on.</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Variable</th>
                                <th>Contains</th>
                                <th>Example</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>$1</code></td>
                                <td>First argument</td>
                                <td><code>./script.sh hello</code> → <code>$1</code> = "hello"</td>
                            </tr>
                            <tr>
                                <td><code>$2</code></td>
                                <td>Second argument</td>
                                <td><code>./script.sh hello world</code> → <code>$2</code> = "world"</td>
                            </tr>
                            <tr>
                                <td><code>$3</code> - <code>$9</code></td>
                                <td>Third through ninth arguments</td>
                                <td>Access arguments by position</td>
                            </tr>
                            <tr>
                                <td><code>\${10}</code>+</code></td>
                                <td>Arguments beyond 9th</td>
                                <td>Use braces: <code>\${10}</code>, <code>\${11}</code>, etc.</td>
                            </tr>
                        </tbody>
                    </table>

                    <pre><code class="language-bash">#!/bin/bash
# Accessing arguments
echo "First argument: $1"
echo "Second argument: $2"
echo "Third argument: $3"

# Run with: ./script.sh apple banana cherry</code></pre>

                    <div class="info-box">
                        <strong>Accessing Arguments Beyond $9:</strong> For the 10th argument and beyond, you must use braces: <code>\${10}</code>, <code>\${11}</code>, etc. Without braces, <code>$10</code> would be interpreted as <code>$1</code> followed by the literal "0"!
                    </div>

                    <!-- Section 3: Number of Arguments $# -->
                    <h2>Number of Arguments: $#</h2>
                    <p>The <code>$#</code> variable contains the total number of arguments passed to the script. This is essential for argument validation.</p>

                    <pre><code class="language-bash">#!/bin/bash
echo "Number of arguments: $#"

# Validate argument count
if [ $# -lt 2 ]; then
    echo "Error: Need at least 2 arguments"
    echo "Usage: $0 &lt;arg1&gt; &lt;arg2&gt;"
    exit 1
fi

echo "First arg: $1"
echo "Second arg: $2"</code></pre>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 4: All Arguments: $@ and $* -->
                    <h2>All Arguments: $@ and $*</h2>
                    <p>Both <code>$@</code> and <code>$*</code> represent all arguments, but they behave differently when quoted. Understanding this difference is crucial for writing robust scripts!</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Variable</th>
                                <th>Behavior</th>
                                <th>When to Use</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>"$@"</code></td>
                                <td>Each argument as separate word (preserves spaces)</td>
                                <td><strong>Recommended</strong> - for passing arguments to other commands</td>
                            </tr>
                            <tr>
                                <td><code>"$*"</code></td>
                                <td>All arguments as single string (joined by IFS)</td>
                                <td>When you want all args as one string</td>
                            </tr>
                            <tr>
                                <td><code>$@</code> (unquoted)</td>
                                <td>Same as <code>"$@"</code> when used in loops</td>
                                <td>In for loops: <code>for arg in $@</code></td>
                            </tr>
                            <tr>
                                <td><code>$*</code> (unquoted)</td>
                                <td>Subject to word splitting (not recommended)</td>
                                <td>Avoid unquoted <code>$*</code></td>
                            </tr>
                        </tbody>
                    </table>

                    <pre><code class="language-bash">#!/bin/bash
# Difference between $@ and $*

# With arguments: ./script.sh "hello world" "foo bar"

echo "Using \$@ (each argument separately):"
for arg in "$@"; do
    echo "  - '$arg'"
done
# Output:
#   - 'hello world'
#   - 'foo bar'

echo ""
echo "Using \$* (all as one string):"
echo "  '$*'"
# Output: 'hello world foo bar'</code></pre>

                    <div class="warning-box">
                        <strong>Important:</strong> Always use <code>"$@"</code> when passing arguments to other commands! This preserves spaces in arguments and handles special characters correctly. Unquoted <code>$@</code> or <code>$*</code> can break with arguments containing spaces.
                    </div>

                    <!-- Section 5: Process ID: $$ -->
                    <h2>Process ID: $$</h2>
                    <p>The <code>$$</code> variable contains the Process ID (PID) of the current shell or script. This is useful for creating unique temporary files, logging, and process management.</p>

                    <pre><code class="language-bash">#!/bin/bash
echo "This script's process ID: $$"

# Create unique temporary file
TEMP_FILE="/tmp/script_$$.tmp"
echo "Creating temp file: $TEMP_FILE"
touch "$TEMP_FILE"

# Cleanup on exit
trap "rm -f $TEMP_FILE" EXIT</code></pre>

                    <!-- Section 6: Exit Status: $? -->
                    <h2>Exit Status: $?</h2>
                    <p>The <code>$?</code> variable contains the exit status of the last executed command. This is essential for error handling and conditional logic.</p>

                    <pre><code class="language-bash">#!/bin/bash
# Exit status is 0 for success, non-zero for failure

# Run a command
ls /nonexistent 2>/dev/null

# Check exit status
if [ $? -eq 0 ]; then
    echo "Command succeeded"
else
    echo "Command failed with exit code: $?"
fi

# Check exit status immediately (before it changes)
ls /tmp
echo "Exit status: $?"  # Must check immediately!

# After another command, $? changes
echo "test"
echo "Previous exit status lost: $?"  # This shows echo's exit status (0)</code></pre>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Exit Code</th>
                                <th>Meaning</th>
                                <th>Example</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>0</code></td>
                                <td>Success</td>
                                <td><code>ls</code> found files</td>
                            </tr>
                            <tr>
                                <td><code>1</code></td>
                                <td>General error</td>
                                <td><code>grep</code> found nothing</td>
                            </tr>
                            <tr>
                                <td><code>2</code></td>
                                <td>Misuse of command</td>
                                <td><code>ls</code> with invalid option</td>
                            </tr>
                            <tr>
                                <td><code>126</code></td>
                                <td>Command not executable</td>
                                <td>Permission denied</td>
                            </tr>
                            <tr>
                                <td><code>127</code></td>
                                <td>Command not found</td>
                                <td>Command doesn't exist</td>
                            </tr>
                            <tr>
                                <td><code>130</code></td>
                                <td>Terminated by Ctrl+C</td>
                                <td>User interruption</td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Check <code>$?</code> immediately after a command, before running any other command! Each new command overwrites <code>$?</code> with its own exit status.
                    </div>

                    <!-- Section 7: Background Process ID: $! -->
                    <h2>Background Process ID: $!</h2>
                    <p>The <code>$!</code> variable contains the Process ID of the last background job. This is useful for managing background processes.</p>

                    <pre><code class="language-bash">#!/bin/bash
# Start a background job
sleep 10 &
BG_PID=$!

echo "Background process started with PID: $BG_PID"

# Wait for it to finish
wait $BG_PID
echo "Background process finished"</code></pre>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Using $* instead of "$@" when passing arguments</h4>
                        <pre><code class="language-bash"># Wrong - loses individual arguments
function process_args() {
    for arg in "$*"; do
        echo "$arg"  # Only one iteration, all args joined!
    done
}

# Correct - preserves individual arguments
function process_args() {
    for arg in "$@"; do
        echo "$arg"  # One iteration per argument
    done
}</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Not checking $? immediately after command</h4>
                        <pre><code class="language-bash"># Wrong - $? might change
ls /tmp
echo "Something"
if [ $? -eq 0 ]; then  # Checks echo's exit status, not ls!
    echo "ls succeeded"
fi

# Correct - check immediately
ls /tmp
if [ $? -eq 0 ]; then  # Checks ls exit status
    echo "ls succeeded"
fi

# Even better - use if directly
if ls /tmp > /dev/null 2>&1; then
    echo "ls succeeded"
fi</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Accessing $10 without braces</h4>
                        <pre><code class="language-bash"># Wrong - interpreted as $1 + "0"
echo $10  # Prints value of $1 followed by literal "0"

# Correct - use braces
echo \${10}  # Prints 10th argument</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Assuming arguments exist without checking</h4>
                        <pre><code class="language-bash"># Wrong - no error handling
echo "First arg: $1"
echo "Second arg: $2"

# Correct - validate first
if [ $# -lt 2 ]; then
    echo "Error: Need 2 arguments"
    exit 1
fi
echo "First arg: $1"
echo "Second arg: $2"</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Create an Argument Processor</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a script that processes command-line arguments!</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Display the script name</li>
                            <li>Display the total number of arguments</li>
                            <li>Validate that at least 2 arguments are provided</li>
                            <li>Display all arguments using <code>$@</code></li>
                            <li>Display the first and second arguments</li>
                            <li>Check if a command succeeds and display its exit status</li>
                        </ul>

                        <p><strong>Test with:</strong> <code>bash script.sh apple banana cherry</code></p>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-bash">#!/bin/bash
# Argument processor script

# Display script name
echo "Script name: $0"
echo ""

# Display argument count
echo "Number of arguments: $#"
echo ""

# Validate arguments
if [ $# -lt 2 ]; then
    echo "Error: Need at least 2 arguments"
    echo "Usage: $0 &lt;arg1&gt; &lt;arg2&gt; [arg3...]"
    exit 1
fi

# Display all arguments
echo "All arguments (\$@):"
for arg in "$@"; do
    echo "  - $arg"
done
echo ""

# Display first two arguments
echo "First argument: $1"
echo "Second argument: $2"
echo ""

# Check command exit status
ls /tmp > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "ls /tmp succeeded (exit status: $?)"
else
    echo "ls /tmp failed (exit status: $?)"
fi</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>$0:</strong> Script or command name</li>
                            <li><strong>$1-$9:</strong> First 9 command-line arguments</li>
                            <li><strong>\${10}+:</strong> Arguments beyond 9th (must use braces)</li>
                            <li><strong>$#:</strong> Total number of arguments</li>
                            <li><strong>"$@":</strong> All arguments as separate words (recommended)</li>
                            <li><strong>"$*":</strong> All arguments as single string</li>
                            <li><strong>$$:</strong> Current process ID (PID)</li>
                            <li><strong>$?:</strong> Exit status of last command (0 = success, non-zero = error)</li>
                            <li><strong>$!:</strong> Process ID of last background job</li>
                            <li><strong>Always use "$@"</strong> when passing arguments to preserve spaces</li>
                            <li><strong>Check $? immediately</strong> after commands, before running other commands</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Excellent! You've mastered special variables for handling command-line arguments. Next, we'll explore <strong>Arrays</strong> - a powerful way to store and manipulate multiple values. Arrays let you work with lists of items, iterate through them, and perform bulk operations efficiently!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="variables-environment.jsp" />
                    <jsp:param name="prevTitle" value="Environment Variables" />
                    <jsp:param name="nextLink" value="variables-arrays.jsp" />
                    <jsp:param name="nextTitle" value="Arrays" />
                    <jsp:param name="currentLessonId" value="variables-special" />
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

