<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "terminal-basics");
   request.setAttribute("currentModule", "Getting Started"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Terminal Basics - Essential Commands for Bash Scripting | 8gwifi.org</title>
    <meta name="description"
        content="Master essential terminal commands: navigation (cd, pwd, ls), file operations (touch, mkdir, rm, cp, mv), and basic commands you'll use constantly in Bash scripting.">
    <meta name="keywords"
        content="bash terminal commands, cd pwd ls, bash file operations, touch mkdir rm, learn terminal basics, bash navigation, unix commands">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Terminal Basics - Essential Commands for Bash Scripting">
    <meta property="og:description" content="Master essential terminal commands for navigation and file operations - the foundation of Bash scripting.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/terminal-basics.jsp">
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
        "name": "Terminal Basics",
        "description": "Master essential terminal commands for navigation and file operations - the foundation of Bash scripting.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Navigation commands", "cd, pwd, ls", "File operations", "touch, mkdir, rm", "cp, mv commands", "Basic terminal usage"],
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

<body class="tutorial-body no-preview" data-lesson="terminal-basics">
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
                    <span>Terminal Basics</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Terminal Basics</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~20 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Before diving deeper into Bash scripting, it's essential to master the basic terminal commands. These commands form the foundation of everything you'll do in Bash. You'll learn navigation commands to move around your file system, file operations to create and manipulate files, and other essential commands that you'll use constantly.</p>

                    <!-- Section 1: Navigation Commands -->
                    <h2>Navigation Commands</h2>
                    <p>Moving around your file system is one of the most fundamental skills. These commands help you navigate directories and understand where you are.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/terminal-basics.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-terminal-basics" />
                    </jsp:include>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Command</th>
                                <th>Description</th>
                                <th>Example</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>pwd</code></td>
                                <td>Print Working Directory - shows current directory</td>
                                <td><code>pwd</code> → <code>/home/user</code></td>
                            </tr>
                            <tr>
                                <td><code>cd</code></td>
                                <td>Change Directory - navigate to a directory</td>
                                <td><code>cd /tmp</code> or <code>cd ~</code></td>
                            </tr>
                            <tr>
                                <td><code>cd ~</code></td>
                                <td>Go to home directory</td>
                                <td><code>cd ~</code></td>
                            </tr>
                            <tr>
                                <td><code>cd ..</code></td>
                                <td>Go up one directory level</td>
                                <td><code>cd ..</code></td>
                            </tr>
                            <tr>
                                <td><code>cd -</code></td>
                                <td>Go to previous directory</td>
                                <td><code>cd -</code></td>
                            </tr>
                            <tr>
                                <td><code>ls</code></td>
                                <td>List files and directories</td>
                                <td><code>ls -la</code></td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="info-box">
                        <strong>Special Directory Shortcuts:</strong><br>
                        - <code>~</code> - Your home directory (<code>/home/username</code> or <code>/Users/username</code>)<br>
                        - <code>.</code> - Current directory<br>
                        - <code>..</code> - Parent directory<br>
                        - <code>-</code> - Previous directory (used with <code>cd</code>)
                    </div>

                    <!-- Section 2: Listing Files -->
                    <h2>Listing Files (ls)</h2>
                    <p>The <code>ls</code> command lists files and directories. It has many useful options for different views.</p>

                    <pre><code class="language-bash"># Basic listing
ls

# Long format with details
ls -l

# Show hidden files (starting with .)
ls -a

# Long format + hidden files
ls -la

# Human-readable file sizes
ls -lh

# Sort by modification time (newest first)
ls -lt

# Reverse order
ls -lr

# Recursive (show subdirectories)
ls -R</code></pre>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> The <code>-l</code> flag shows file permissions, ownership, size, and modification date. Combined with <code>-h</code> (human-readable), you get sizes in KB, MB, GB instead of bytes!
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: File Operations -->
                    <h2>File Operations</h2>
                    <p>Creating, copying, moving, and deleting files are essential operations you'll perform constantly in Bash scripts.</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Command</th>
                                <th>Description</th>
                                <th>Example</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>touch</code></td>
                                <td>Create empty file or update timestamp</td>
                                <td><code>touch file.txt</code></td>
                            </tr>
                            <tr>
                                <td><code>mkdir</code></td>
                                <td>Create directory</td>
                                <td><code>mkdir mydir</code> or <code>mkdir -p path/to/dir</code></td>
                            </tr>
                            <tr>
                                <td><code>cp</code></td>
                                <td>Copy file or directory</td>
                                <td><code>cp source.txt dest.txt</code> or <code>cp -r dir1 dir2</code></td>
                            </tr>
                            <tr>
                                <td><code>mv</code></td>
                                <td>Move or rename file/directory</td>
                                <td><code>mv old.txt new.txt</code> or <code>mv file.txt /tmp/</code></td>
                            </tr>
                            <tr>
                                <td><code>rm</code></td>
                                <td>Remove file</td>
                                <td><code>rm file.txt</code> or <code>rm -rf dir/</code></td>
                            </tr>
                            <tr>
                                <td><code>rmdir</code></td>
                                <td>Remove empty directory</td>
                                <td><code>rmdir emptydir</code></td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="warning-box">
                        <strong>⚠️ Danger Zone:</strong> Be very careful with <code>rm -rf</code>!<br>
                        - <code>-r</code> means recursive (deletes directories and contents)<br>
                        - <code>-f</code> means force (no confirmation prompts)<br>
                        - There's no "undo" or "trash" - deleted files are gone forever!<br>
                        - Double-check paths before using <code>rm -rf</code>
                    </div>

                    <!-- Section 4: Useful Options -->
                    <h2>Common Command Options</h2>
                    <p>Many commands share similar options. Understanding these patterns makes learning new commands easier.</p>

                    <pre><code class="language-bash"># mkdir -p creates parent directories if needed
mkdir -p project/src/main/java

# cp -r copies directories recursively
cp -r source_dir/ dest_dir/

# rm -i prompts before deleting (safer)
rm -i important_file.txt

# mv can rename files
mv oldname.txt newname.txt

# Multiple operations
touch file1.txt file2.txt file3.txt
mkdir dir1 dir2 dir3</code></pre>

                    <div class="info-box">
                        <strong>Common Options Pattern:</strong><br>
                        - <code>-a</code> or <code>--all</code> - Show/all (including hidden)<br>
                        - <code>-r</code> or <code>-R</code> - Recursive (for directories)<br>
                        - <code>-f</code> - Force (no prompts)<br>
                        - <code>-i</code> - Interactive (prompt before actions)<br>
                        - <code>-v</code> - Verbose (show what's happening)<br>
                        - <code>-h</code> - Human-readable (sizes, dates)
                    </div>

                    <!-- Section 5: Other Essential Commands -->
                    <h2>Other Essential Commands</h2>
                    <p>These commands are frequently used in scripts and daily terminal work.</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Command</th>
                                <th>Description</th>
                                <th>Use Case</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>cat</code></td>
                                <td>Display file contents</td>
                                <td><code>cat file.txt</code></td>
                            </tr>
                            <tr>
                                <td><code>less</code> / <code>more</code></td>
                                <td>View file page by page</td>
                                <td><code>less longfile.txt</code></td>
                            </tr>
                            <tr>
                                <td><code>head</code></td>
                                <td>Show first lines of file</td>
                                <td><code>head -n 10 file.txt</code></td>
                            </tr>
                            <tr>
                                <td><code>tail</code></td>
                                <td>Show last lines of file</td>
                                <td><code>tail -f logfile.txt</code> (follow mode)</td>
                            </tr>
                            <tr>
                                <td><code>find</code></td>
                                <td>Search for files</td>
                                <td><code>find . -name "*.txt"</code></td>
                            </tr>
                            <tr>
                                <td><code>grep</code></td>
                                <td>Search text in files</td>
                                <td><code>grep "error" logfile.txt</code></td>
                            </tr>
                            <tr>
                                <td><code>which</code></td>
                                <td>Show path to command</td>
                                <td><code>which python</code></td>
                            </tr>
                            <tr>
                                <td><code>whoami</code></td>
                                <td>Show current username</td>
                                <td><code>whoami</code></td>
                            </tr>
                            <tr>
                                <td><code>date</code></td>
                                <td>Show current date/time</td>
                                <td><code>date</code> or <code>date +"%Y-%m-%d"</code></td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Not understanding relative vs absolute paths</h4>
                        <pre><code class="language-bash"># Wrong - assuming you're in a specific directory
cd documents/project  # Fails if not in home directory

# Correct - use absolute path or check current location
cd ~/documents/project  # Absolute path from home
# Or
pwd  # Check where you are first
cd documents/project  # Then use relative path</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Using rm without -r for directories</h4>
                        <pre><code class="language-bash"># Wrong - rm doesn't remove directories
rm mydir  # Error: is a directory

# Correct - use rmdir for empty dirs or rm -r for non-empty
rmdir mydir  # Only works if directory is empty
rm -r mydir  # Removes directory and contents
rm -rf mydir  # Force remove (no prompts)</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Not creating parent directories with mkdir</h4>
                        <pre><code class="language-bash"># Wrong - fails if parent doesn't exist
mkdir project/src/main  # Error if project/src doesn't exist

# Correct - use -p to create parent directories
mkdir -p project/src/main  # Creates all necessary directories</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Confusing cp and mv</h4>
                        <pre><code class="language-bash"># cp - copies file (original remains)
cp file.txt backup.txt  # Now you have both files

# mv - moves/renames file (original is gone)
mv file.txt renamed.txt  # file.txt no longer exists, renamed.txt does

# Use cp when you want to keep original
# Use mv when you want to move or rename</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Navigate and Organize Files</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Practice using terminal commands to create a project structure!</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Create a directory called <code>myproject</code></li>
                            <li>Inside it, create subdirectories: <code>src</code>, <code>docs</code>, <code>scripts</code></li>
                            <li>Create a file called <code>README.txt</code> in the main directory</li>
                            <li>Copy <code>README.txt</code> to the <code>docs</code> directory</li>
                            <li>List all files and directories in your project</li>
                            <li>Show the full path to your project directory</li>
                        </ul>

                        <p><strong>Hint:</strong> Use <code>mkdir -p</code> to create nested directories, and remember to navigate with <code>cd</code>!</p>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-bash"># Create project directory
mkdir -p myproject/src myproject/docs myproject/scripts

# Navigate into project
cd myproject

# Create README file
touch README.txt

# Copy to docs directory
cp README.txt docs/

# List all files
ls -la

# Show full path
pwd

# Or use find to see structure
find . -type f</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Navigation:</strong> <code>pwd</code> (where am I), <code>cd</code> (change directory), <code>ls</code> (list files)</li>
                            <li><strong>File Creation:</strong> <code>touch</code> (create file), <code>mkdir</code> (create directory)</li>
                            <li><strong>File Operations:</strong> <code>cp</code> (copy), <code>mv</code> (move/rename), <code>rm</code> (remove)</li>
                            <li><strong>Useful Options:</strong> <code>-r</code> (recursive), <code>-f</code> (force), <code>-i</code> (interactive), <code>-a</code> (all), <code>-l</code> (long format), <code>-h</code> (human-readable)</li>
                            <li><strong>Special Directories:</strong> <code>~</code> (home), <code>.</code> (current), <code>..</code> (parent), <code>-</code> (previous)</li>
                            <li><strong>Safety:</strong> Be careful with <code>rm -rf</code> - there's no undo! Use <code>-i</code> for safety.</li>
                            <li><strong>Other Commands:</strong> <code>cat</code>, <code>head</code>, <code>tail</code>, <code>find</code>, <code>grep</code>, <code>which</code>, <code>whoami</code>, <code>date</code></li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Excellent! You've mastered the essential terminal commands. Now that you understand navigation and file operations, we're ready to dive into <strong>Variables & Environment</strong>. You'll learn how to store data in variables, work with environment variables, use special variables, and handle arrays - the building blocks of powerful Bash scripts!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="first-script.jsp" />
                    <jsp:param name="prevTitle" value="First Script" />
                    <jsp:param name="nextLink" value="variables-basics.jsp" />
                    <jsp:param name="nextTitle" value="Variables" />
                    <jsp:param name="currentLessonId" value="terminal-basics" />
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

