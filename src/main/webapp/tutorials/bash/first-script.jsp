<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "first-script");
   request.setAttribute("currentModule", "Getting Started"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>First Bash Script - Shebang, Executable Permissions, Running Scripts | 8gwifi.org</title>
    <meta name="description"
        content="Write your first Bash script! Learn about the shebang (#!), making scripts executable with chmod, running scripts, and understanding comments in Bash.">
    <meta name="keywords"
        content="bash first script, bash shebang, chmod executable, bash comments, run bash script, bash script tutorial, learn bash scripting">

    <meta property="og:type" content="article">
    <meta property="og:title" content="First Bash Script - Shebang, Executable Permissions, Running Scripts">
    <meta property="og:description" content="Write your first Bash script. Learn the shebang line, making scripts executable, and running your scripts.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/first-script.jsp">
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
        "name": "First Bash Script",
        "description": "Write your first Bash script. Learn about the shebang (#!), making scripts executable with chmod, and running scripts.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Shebang line", "Making scripts executable", "chmod command", "Running scripts", "Bash comments", "Script structure"],
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

<body class="tutorial-body no-preview" data-lesson="first-script">
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
                    <span>First Script</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">First Bash Script</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~15 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Now let's write your first Bash script! A Bash script is simply a text file containing Bash commands that can be executed like a program. You'll learn about the shebang line that tells the system which interpreter to use, how to make scripts executable, and different ways to run your scripts.</p>

                    <!-- Section 1: The Shebang -->
                    <h2>The Shebang (#!)</h2>
                    <p>The shebang (also called hashbang) is a special line at the beginning of a script that tells the operating system which interpreter to use. It always starts with <code>#!</code> followed by the path to the interpreter.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/first-script.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-script-structure" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Common Shebang Lines:</strong><br>
                        - <code>#!/bin/bash</code> - Use Bash interpreter<br>
                        - <code>#!/bin/sh</code> - Use POSIX-compliant shell (more portable)<br>
                        - <code>#!/usr/bin/env bash</code> - Use bash from PATH (more flexible)<br>
                        - <code>#!/usr/bin/python3</code> - For Python scripts<br>
                        The shebang must be on the first line, and there should be no spaces before it!
                    </div>

                    <!-- Section 2: Hello World Script -->
                    <h2>Your First "Hello World" Script</h2>
                    <p>Let's create a simple script that prints "Hello, World!" to the screen. This is the traditional first program in any language!</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/first-hello-world.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-hello-world" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> The <code>echo</code> command is Bash's way of printing output. It's similar to <code>print()</code> in Python or <code>console.log()</code> in JavaScript. You'll use it constantly in Bash scripts!
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Making Scripts Executable -->
                    <h2>Making Scripts Executable</h2>
                    <p>Before you can run a script directly (like <code>./script.sh</code>), you need to make it executable using the <code>chmod</code> command. This grants execute permissions to the file.</p>

                    <pre><code class="language-bash"># Make a script executable
chmod +x script.sh

# Or be more specific (read, write, execute for owner)
chmod 755 script.sh

# Check file permissions
ls -l script.sh</code></pre>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Permission</th>
                                <th>Symbol</th>
                                <th>Numeric</th>
                                <th>Description</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Read</td>
                                <td><code>r</code></td>
                                <td><code>4</code></td>
                                <td>Can view file contents</td>
                            </tr>
                            <tr>
                                <td>Write</td>
                                <td><code>w</code></td>
                                <td><code>2</code></td>
                                <td>Can modify file contents</td>
                            </tr>
                            <tr>
                                <td>Execute</td>
                                <td><code>x</code></td>
                                <td><code>1</code></td>
                                <td>Can run file as program</td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="info-box">
                        <strong>Understanding chmod:</strong><br>
                        - <code>chmod +x</code> adds execute permission for all (user, group, others)<br>
                        - <code>chmod 755</code> means: owner can read/write/execute (7), group and others can read/execute (5)<br>
                        - The first digit is for owner, second for group, third for others<br>
                        - 7 = 4+2+1 (read+write+execute), 5 = 4+1 (read+execute)
                    </div>

                    <!-- Section 4: Running Scripts -->
                    <h2>Running Bash Scripts</h2>
                    <p>There are several ways to execute a Bash script. Each method has its use cases:</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Method</th>
                                <th>Command</th>
                                <th>When to Use</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>Direct execution</strong></td>
                                <td><code>./script.sh</code></td>
                                <td>Script is executable and in current directory</td>
                            </tr>
                            <tr>
                                <td><strong>Using bash</strong></td>
                                <td><code>bash script.sh</code></td>
                                <td>Script doesn't need execute permission, or you want to specify interpreter</td>
                            </tr>
                            <tr>
                                <td><strong>With sh</strong></td>
                                <td><code>sh script.sh</code></td>
                                <td>For POSIX compatibility or when bash isn't available</td>
                            </tr>
                            <tr>
                                <td><strong>Source/Execute</strong></td>
                                <td><code>source script.sh</code> or <code>. script.sh</code></td>
                                <td>Run in current shell (affects current environment, useful for config files)</td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="warning-box">
                        <strong>Important:</strong> The difference between <code>./script.sh</code> and <code>source script.sh</code>:<br>
                        - <code>./script.sh</code> runs in a new subshell - changes don't affect your current session<br>
                        - <code>source script.sh</code> runs in the current shell - variables and functions become available in your session<br>
                        Use <code>source</code> for configuration files, use <code>./</code> for standalone scripts!
                    </div>

                    <!-- Section 5: Comments -->
                    <h2>Comments in Bash</h2>
                    <p>Comments help explain your code to others (and to yourself later!). In Bash, everything after <code>#</code> on a line is ignored by the interpreter, except when the <code>#</code> is part of a string or the shebang.</p>

                    <pre><code class="language-bash">#!/bin/bash
# This is a single-line comment

# Multiple single-line comments
# can explain complex logic
# across several lines

echo "Hello"  # Inline comment - explains this line

# Block comments in Bash require # on each line
# There's no /* */ style block comment like in C/Java
# But you can use multi-line comments with : '...'
: '
This is a multi-line comment
that spans several lines
using the null command
'</code></pre>

                    <div class="tip-box">
                        <strong>Comment Best Practices:</strong><br>
                        - Explain <em>why</em> you're doing something, not <em>what</em> (code should be self-explanatory)<br>
                        - Use comments for complex logic, non-obvious workarounds, or important notes<br>
                        - Keep comments up-to-date when code changes<br>
                        - Don't over-comment simple, obvious code!
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Missing shebang or wrong shebang</h4>
                        <pre><code class="language-bash"># Wrong - no shebang
echo "Hello"
# Script may work but is less portable

# Wrong - space before shebang
 #!/bin/bash
echo "Hello"

# Correct
#!/bin/bash
echo "Hello"</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Forgetting to make script executable</h4>
                        <pre><code class="language-bash"># Creating script
echo '#!/bin/bash
echo "Hello"' > script.sh

# Wrong - trying to run without permissions
./script.sh
# Error: Permission denied

# Correct - make executable first
chmod +x script.sh
./script.sh
# Or run with: bash script.sh</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Wrong path in shebang</h4>
                        <pre><code class="language-bash"># Wrong - bash might be in /usr/bin/bash on some systems
#!/bin/bash

# Better - more portable
#!/usr/bin/env bash

# Check where bash is located
which bash</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Windows line endings (CRLF) causing issues</h4>
                        <pre><code class="language-bash"># Wrong - Windows line endings (CRLF) cause: bad interpreter error
#!/bin/bash\r
echo "Hello"

# Correct - Unix line endings (LF)
#!/bin/bash
echo "Hello"

# Fix with: dos2unix script.sh or sed -i 's/\r$//' script.sh</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Create and Run Your Script</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a Bash script that introduces yourself!</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Start with the shebang line</li>
                            <li>Print your name</li>
                            <li>Print the current date</li>
                            <li>Print your current directory</li>
                            <li>Include at least two comments explaining what the script does</li>
                            <li>Make it executable and run it</li>
                        </ul>

                        <p><strong>Hint:</strong> Use <code>date</code> and <code>pwd</code> commands. Don't forget the shebang!</p>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-bash">#!/bin/bash
# Introduction script
# This script introduces the user and shows system information

# Print name
echo "Hello! My name is Alex."
echo ""

# Print current date
echo "Today's date is:"
date
echo ""

# Print current directory
echo "I am currently in:"
pwd</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Shebang:</strong> <code>#!/bin/bash</code> on the first line tells the system which interpreter to use</li>
                            <li><strong>Comments:</strong> Use <code>#</code> for single-line comments; everything after <code>#</code> is ignored</li>
                            <li><strong>Executable Permission:</strong> Use <code>chmod +x script.sh</code> to make scripts executable</li>
                            <li><strong>Running Scripts:</strong> <code>./script.sh</code> (direct), <code>bash script.sh</code> (via interpreter), or <code>source script.sh</code> (in current shell)</li>
                            <li><strong>File Extensions:</strong> Use <code>.sh</code> extension for clarity (though not required)</li>
                            <li><strong>Line Endings:</strong> Use Unix (LF) not Windows (CRLF) line endings</li>
                            <li><strong>Portable Shebang:</strong> <code>#!/usr/bin/env bash</code> is more portable than <code>#!/bin/bash</code></li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Great job on creating your first Bash script! In the next lesson, we'll explore <strong>Terminal Basics</strong> - essential commands like <code>cd</code>, <code>ls</code>, <code>pwd</code>, and file operations that you'll use constantly when working with Bash and the command line.</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="intro.jsp" />
                    <jsp:param name="prevTitle" value="Introduction" />
                    <jsp:param name="nextLink" value="terminal-basics.jsp" />
                    <jsp:param name="nextTitle" value="Terminal Basics" />
                    <jsp:param name="currentLessonId" value="first-script" />
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

