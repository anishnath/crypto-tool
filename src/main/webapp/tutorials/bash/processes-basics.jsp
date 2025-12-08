<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "processes-basics");
   request.setAttribute("currentModule", "Advanced Topics"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Process Basics - Bash Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn Bash process basics: Process IDs (PID, PPID), background processes, $$ and $! variables, process management fundamentals in shell scripts.">
    <meta name="keywords"
        content="bash processes, bash PID, bash PPID, bash background processes, bash process ID, shell process management">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Process Basics - Bash Tutorial">
    <meta property="og:description" content="Master the fundamentals of process management in Bash.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/processes-basics.jsp">
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
        "name": "Bash Process Basics",
        "description": "Learn Bash process basics: Process IDs, background processes, and process management fundamentals.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Process IDs", "PID and PPID", "Background processes", "$$ variable", "$! variable", "Process management"],
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

<body class="tutorial-body no-preview" data-lesson="processes-basics">
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
                    <span>Process Basics</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Process Basics</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Understanding processes is fundamental to Bash scripting. Every running program is a process with a unique Process ID (PID). Bash provides special variables to work with processes, allowing you to manage background jobs, track process IDs, and coordinate multiple processes. Mastering process basics is essential for building robust, efficient scripts that can handle concurrent operations!</p>

                    <!-- Section 1: Process IDs -->
                    <h2>Process IDs (PID)</h2>
                    <p>Every process has a unique Process ID (PID). Bash provides special variables to access process IDs:</p>

                    <ul>
                        <li><code>$$</code>: PID of the current shell/script</li>
                        <li><code>$!</code>: PID of the last background process</li>
                        <li><code>$PPID</code>: Parent Process ID (the process that started this one)</li>
                    </ul>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/processes-basics.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-processes-basics" />
                        <jsp:param name="filename" value="processes-basics.sh" />
                    </jsp:include>

                    <pre><code class="language-bash"># Get current process ID
echo "Current script PID: $$"

# Get parent process ID
echo "Parent PID: $PPID"

# Start background process and capture PID
sleep 10 &
bg_pid=$!
echo "Background process PID: $bg_pid"</code></pre>

                    <div class="info-box">
                        <strong>Key Points:</strong><br>
                        - <code>$$</code> is the PID of the current shell/script<br>
                        - <code>$!</code> stores the PID of the most recently started background process<br>
                        - <code>$PPID</code> is the PID of the parent process<br>
                        - Process IDs are unique and sequential (incrementing)
                    </div>

                    <!-- Section 2: Background Processes -->
                    <h2>Running Processes in Background</h2>
                    <p>You can run commands in the background by appending <code>&</code> to the command. This allows your script to continue executing while the command runs.</p>

                    <pre><code class="language-bash"># Run command in background
long_running_command &

# Capture the PID immediately after starting
sleep 60 &
bg_pid=$!
echo "Started process with PID: $bg_pid"

# Check if process is running
ps -p $bg_pid > /dev/null 2>&1 && echo "Process is running" || echo "Process finished"</code></pre>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Always capture the PID immediately after starting a background process. The <code>$!</code> variable updates after each background command, so store it in a variable right away!
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                        <jsp:param name="responsive" value="true" />
                    </jsp:include>

                    <!-- Section 3: Process Status -->
                    <h2>Checking Process Status</h2>
                    <p>You can check if a process is still running using the <code>ps</code> command or by checking the exit status:</p>

                    <pre><code class="language-bash"># Check if process is running
pid=12345
if ps -p $pid > /dev/null 2>&1; then
    echo "Process $pid is running"
else
    echo "Process $pid has finished"
fi

# Wait for background process and check exit status
sleep 5 &
bg_pid=$!
wait $bg_pid
exit_status=$?
echo "Process $bg_pid exited with status: $exit_status"</code></pre>

                    <!-- Section 4: Parent and Child Processes -->
                    <h2>Parent and Child Processes</h2>
                    <p>When a script starts another process, the script is the parent and the new process is the child. Understanding this relationship is important for process management:</p>

                    <pre><code class="language-bash">#!/bin/bash
# Parent process
echo "Parent PID: $$"
echo "Parent's parent PID: $PPID"

# Start child process
sleep 10 &
child_pid=$!
echo "Child process PID: $child_pid"

# In the child process context (if script calls itself or another script)
# $$ would be the child's PID
# $PPID would be this script's PID</code></pre>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Not capturing PID immediately</h4>
                        <pre><code class="language-bash"># Wrong - $! changes after each background command
sleep 10 &
sleep 5 &  # $! now points to this, not the first sleep
pid=$!
echo "First sleep PID: $pid"  # Wrong! This is the second sleep's PID

# Correct - capture immediately
sleep 10 &
first_pid=$!
sleep 5 &
second_pid=$!
echo "First: $first_pid, Second: $second_pid"</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Assuming process is still running</h4>
                        <pre><code class="language-bash"># Wrong - process might have finished
sleep 10 &
pid=$!
# ... do other things ...
kill $pid  # Might fail if process already finished

# Correct - check first
sleep 10 &
pid=$!
if ps -p $pid > /dev/null 2>&1; then
    kill $pid
    echo "Process killed"
else
    echo "Process already finished"
fi</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Confusing $$ and $!</h4>
                        <pre><code class="language-bash"># Wrong - $$ is current script, not background process
sleep 10 &
# Later...
kill $$  # Kills the script itself, not the background process!

# Correct - use $! or store PID
sleep 10 &
bg_pid=$!
# Later...
kill $bg_pid  # Kills the background process</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Process Manager</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a script that starts multiple background processes and tracks them!</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Start 3 background processes (sleep commands with different durations)</li>
                            <li>Store each PID in an array</li>
                            <li>Display all PIDs</li>
                            <li>Wait for all processes to complete</li>
                            <li>Display a message when all are done</li>
                        </ul>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-bash">#!/bin/bash
# Process manager exercise

pids=()

# Start 3 background processes
sleep 3 &
pids+=($!)
sleep 5 &
pids+=($!)
sleep 2 &
pids+=($!)

echo "Started processes with PIDs: \${pids[@]}"

# Wait for all processes
for pid in "\${pids[@]}"; do
    wait $pid
    echo "Process $pid completed"
done

echo "All processes finished!"</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>$$</strong>: Current script/shell PID</li>
                            <li><strong>$!</strong>: Last background process PID</li>
                            <li><strong>$PPID</strong>: Parent Process ID</li>
                            <li><strong>&</strong>: Run command in background</li>
                            <li><strong>wait</strong>: Wait for background process to complete</li>
                            <li><strong>ps -p</strong>: Check if process is running</li>
                            <li><strong>Capture PID</strong>: Store <code>$!</code> immediately after starting background process</li>
                            <li><strong>Process Hierarchy</strong>: Scripts can be parents of child processes</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Great! You've learned the basics of process management. Next, we'll dive deeper into <strong>Background Jobs</strong> - managing multiple background processes, job control with <code>jobs</code>, <code>fg</code>, <code>bg</code>, <code>nohup</code>, and <code>disown</code>. These advanced techniques give you fine-grained control over concurrent operations!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="advanced-signals.jsp" />
                    <jsp:param name="prevTitle" value="Signal Handling" />
                    <jsp:param name="nextLink" value="advanced-jobs.jsp" />
                    <jsp:param name="nextTitle" value="Background Jobs" />
                    <jsp:param name="currentLessonId" value="processes-basics" />
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

