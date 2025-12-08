<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "loops-while");
   request.setAttribute("currentModule", "Control Flow"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Bash While & Until Loops - Condition-Based Iteration | 8gwifi.org</title>
    <meta name="description"
        content="Learn Bash while and until loops: condition-based iteration, infinite loops, reading files line by line, and loop control in shell scripts.">
    <meta name="keywords"
        content="bash while loop, bash until loop, bash infinite loop, bash read file, shell scripting while, condition loops">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Bash While & Until Loops - Condition-Based Iteration">
    <meta property="og:description" content="Master while and until loops for condition-based iteration in Bash.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/loops-while.jsp">
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
        "name": "Bash While & Until Loops",
        "description": "Learn Bash while and until loops for condition-based iteration, file reading, and interactive scripts.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["While loops", "Until loops", "Infinite loops", "Reading files", "Condition-based iteration"],
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

<body class="tutorial-body no-preview" data-lesson="loops-while">
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
                    <span>While & Until Loops</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">While & Until Loops</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~20 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">While and until loops provide condition-based iteration, unlike for loops that iterate over lists. While loops continue as long as a condition is true, and until loops continue until a condition becomes true. These loops are essential for reading files line by line, waiting for conditions, creating interactive scripts, and handling situations where you don't know in advance how many iterations you need!</p>

                    <!-- Section 1: While Loop Basics -->
                    <h2>While Loop Basics</h2>
                    <p>A while loop executes its body as long as the condition remains true. The condition is checked before each iteration.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/loops-while.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-while" />
                    </jsp:include>

                    <pre><code class="language-bash"># Basic syntax
while [ condition ]; do
    # code to execute while condition is true
done

# Example: Count from 1 to 5
count=1
while [ $count -le 5 ]; do
    echo "Count: $count"
    count=$((count + 1))
done

# Output:
# Count: 1
# Count: 2
# Count: 3
# Count: 4
# Count: 5</code></pre>

                    <div class="info-box">
                        <strong>Key Points:</strong><br>
                        - Condition is checked <strong>before</strong> each iteration<br>
                        - Loop continues while condition is <strong>true</strong><br>
                        - Make sure condition eventually becomes false to avoid infinite loops<br>
                        - Update loop variable inside the loop body
                    </div>

                    <!-- Section 2: Until Loop -->
                    <h2>Until Loop</h2>
                    <p>An until loop is the opposite of a while loop. It continues <strong>until</strong> the condition becomes true (i.e., while the condition is false).</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/loops-until.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-until" />
                    </jsp:include>

                    <pre><code class="language-bash"># Basic syntax
until [ condition ]; do
    # code to execute until condition becomes true
done

# Example: Countdown
num=5
until [ $num -eq 0 ]; do
    echo "Countdown: $num"
    num=$((num - 1))
done
echo "Blast off!"

# While vs Until comparison:
# while: continues WHILE condition is true
# until: continues UNTIL condition becomes true (while condition is false)</code></pre>

                    <div class="tip-box">
                        <strong>When to Use:</strong><br>
                        - Use <code>while</code> when you want to continue while something is true<br>
                        - Use <code>until</code> when you want to continue until something becomes true<br>
                        - <code>while</code> is more commonly used than <code>until</code>
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Reading Files Line by Line -->
                    <h2>Reading Files Line by Line</h2>
                    <p>While loops are perfect for reading files line by line. This is one of the most common uses of while loops in Bash.</p>

                    <pre><code class="language-bash"># Reading file line by line
while IFS= read -r line; do
    echo "Line: $line"
done < file.txt

# Explanation:
# - IFS= preserves leading/trailing whitespace
# - read -r reads a line (r prevents backslash interpretation)
# - < file.txt redirects file content to stdin

# Processing each line
while IFS= read -r line; do
    if [[ -n "$line" ]]; then  # Skip empty lines
        echo "Processing: $line"
    fi
done < file.txt

# Reading from command output
command | while IFS= read -r line; do
    echo "Output: $line"
done</code></pre>

                    <div class="warning-box">
                        <strong>Important:</strong> When using <code>while read</code> in a pipeline, the loop runs in a subshell, so variables set inside won't persist. Use process substitution or file redirection instead:<br>
                        <code>while read line; do ... done < file.txt</code> ✓<br>
                        <code>command | while read line; do ... done</code> ✗ (subshell)
                    </div>

                    <!-- Section 4: Infinite Loops -->
                    <h2>Infinite Loops</h2>
                    <p>Infinite loops continue forever until explicitly broken. They're useful for interactive programs, servers, and monitoring tasks.</p>

                    <pre><code class="language-bash"># Infinite while loop
while true; do
    echo "This runs forever..."
    sleep 1
    # Use break to exit
done

# Infinite until loop (rarely used)
until false; do
    echo "This also runs forever..."
    sleep 1
done

# Controlled infinite loop
counter=0
while true; do
    counter=$((counter + 1))
    echo "Iteration: $counter"
    
    if [ $counter -ge 5 ]; then
        echo "Breaking at iteration $counter"
        break
    fi
done</code></pre>

                    <div class="info-box">
                        <strong>Infinite Loop Tips:</strong><br>
                        - Always provide a way to exit (break, condition check, or signal handling)<br>
                        - Use <code>sleep</code> in loops that run frequently to avoid high CPU usage<br>
                        - Consider adding timeout mechanisms for long-running loops
                    </div>

                    <!-- Section 5: While with Command Conditions -->
                    <h2>While with Command Conditions</h2>
                    <p>While loops can use command exit codes as conditions. The loop continues while the command succeeds (exit code 0).</p>

                    <pre><code class="language-bash"># While command succeeds
while command; do
    # code
done

# Example: Wait for file to exist
while [ ! -f /tmp/flag.txt ]; do
    echo "Waiting for file..."
    sleep 1
done
echo "File found!"

# Example: Process until command fails
while ping -c 1 google.com &> /dev/null; do
    echo "Network is up"
    sleep 5
done
echo "Network is down"</code></pre>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Infinite loop without exit condition</h4>
                        <pre><code class="language-bash"># Wrong - never updates count
count=1
while [ $count -le 5 ]; do
    echo "$count"
    # Missing: count=$((count + 1))
done  # Infinite loop!

# Correct - update variable inside loop
count=1
while [ $count -le 5 ]; do
    echo "$count"
    count=$((count + 1))  # Update loop variable
done</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Using for instead of while for file reading</h4>
                        <pre><code class="language-bash"># Wrong - splits on spaces, not lines
for line in $(cat file.txt); do
    echo "$line"
done

# Correct - use while read
while IFS= read -r line; do
    echo "$line"
done < file.txt</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Variables in pipeline subshell</h4>
                        <pre><code class="language-bash"># Wrong - count won't persist (subshell)
count=0
cat file.txt | while read line; do
    count=$((count + 1))
done
echo "Lines: $count"  # Prints 0!

# Correct - use file redirection
count=0
while read line; do
    count=$((count + 1))
done < file.txt
echo "Lines: $count"  # Correct count</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Create a File Processor</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a script that uses while loops to process data!</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Use a while loop to count from 1 to 10</li>
                            <li>Create an infinite loop that breaks after 5 iterations</li>
                            <li>Use while read to process lines (simulate with echo)</li>
                            <li>Compare while and until loops side by side</li>
                            <li>Use a while loop to wait for a condition</li>
                        </ul>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-bash">#!/bin/bash
# While loop exercises

# 1. Count 1-10
echo "Counting 1-10:"
count=1
while [ $count -le 10 ]; do
    echo "  $count"
    count=$((count + 1))
done

# 2. Infinite loop with break
echo -e "\nInfinite loop (breaks at 5):"
counter=0
while true; do
    counter=$((counter + 1))
    echo "  Iteration: $counter"
    if [ $counter -ge 5 ]; then
        break
    fi
done

# 3. While read (simulated)
echo -e "\nProcessing lines:"
echo -e "line1\nline2\nline3" | while IFS= read -r line; do
    echo "  Processing: $line"
done

# 4. While vs Until comparison
echo -e "\nWhile loop (count up):"
i=1
while [ $i -le 3 ]; do
    echo "  $i"
    i=$((i + 1))
done

echo -e "\nUntil loop (count up - same logic):"
i=1
until [ $i -gt 3 ]; do  # Note: condition is opposite
    echo "  $i"
    i=$((i + 1))
done</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>While:</strong> <code>while [ condition ]; do ... done</code> continues while true</li>
                            <li><strong>Until:</strong> <code>until [ condition ]; do ... done</code> continues until true</li>
                            <li><strong>File Reading:</strong> Use <code>while IFS= read -r line; do ... done < file</code></li>
                            <li><strong>Infinite:</strong> <code>while true; do ... done</code> with break or condition</li>
                            <strong>Update Variable:</strong> Always update loop variable inside loop body</li>
                            <li><strong>Pipeline:</strong> Avoid <code>command | while</code> (subshell); use redirection</li>
                            <li><strong>Command Condition:</strong> Loop continues while command succeeds (exit 0)</li>
                            <li><strong>When to Use:</strong> When iterations depend on conditions, not list items</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Excellent! You've mastered while and until loops. Next, we'll learn about <strong>Loop Control</strong> statements - <code>break</code>, <code>continue</code>, <code>exit</code>, and <code>return</code>. These give you fine-grained control over loop execution and script flow!</p>
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
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/shell.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>

</html>

