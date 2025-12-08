<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "files-directories");
   request.setAttribute("currentModule", "File Operations"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Working with Directories - Bash Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn Bash directory operations including traversal, recursive processing, find command, and efficient techniques for managing directory structures.">
    <meta name="keywords"
        content="bash directories, bash find command, bash recursive, bash directory traversal, shell script directories, bash globstar">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Working with Directories - Bash Tutorial">
    <meta property="og:description" content="Master directory operations and the powerful find command in Bash.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/files-directories.jsp">
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
        "name": "Bash Working with Directories",
        "description": "Learn directory operations, recursive processing, and the find command in Bash.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["Directory traversal", "Recursive processing", "find command", "Glob patterns", "File counting", "Directory iteration"],
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

<body class="tutorial-body no-preview" data-lesson="files-directories">
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
                    <span>Working with Directories</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Working with Directories</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Directories are the backbone of file organization. This lesson teaches you to navigate, iterate, and process directory contents efficiently. You'll master multiple approaches from simple globs to the powerful <code>find</code> command for handling complex directory operations!</p>

                    <!-- Section 1: Basic Directory Operations -->
                    <h2>Basic Directory Operations</h2>
                    <p>Start with fundamental directory operations: listing contents, iteration, and counting items.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/files-directories.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-basic" />
                    </jsp:include>

                    <h3>Key Directory Commands</h3>
                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Command</th>
                                <th>Purpose</th>
                                <th>Common Options</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>ls</code></td>
                                <td>List directory contents</td>
                                <td><code>-l</code> long, <code>-a</code> all, <code>-h</code> human</td>
                            </tr>
                            <tr>
                                <td><code>cd</code></td>
                                <td>Change directory</td>
                                <td><code>-</code> previous, <code>~</code> home</td>
                            </tr>
                            <tr>
                                <td><code>pwd</code></td>
                                <td>Print working directory</td>
                                <td><code>-P</code> physical path</td>
                            </tr>
                            <tr>
                                <td><code>mkdir</code></td>
                                <td>Create directories</td>
                                <td><code>-p</code> parents, <code>-m</code> mode</td>
                            </tr>
                            <tr>
                                <td><code>rmdir</code></td>
                                <td>Remove empty directories</td>
                                <td><code>-p</code> parents</td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="info-box">
                        <strong>Brace Expansion:</strong> Create multiple directories at once: <code>mkdir -p project/{src,bin,docs,tests}</code>. This creates all four subdirectories in a single command.
                    </div>

                    <!-- Section 2: Recursive Processing -->
                    <h2>Recursive Directory Processing</h2>
                    <p>Processing files in subdirectories requires recursive techniques. Here are four different approaches.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/files-directories-recursive.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-recursive" />
                    </jsp:include>

                    <h3>Choosing the Right Method</h3>
                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Method</th>
                                <th>Pros</th>
                                <th>Cons</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>find -exec</code></td>
                                <td>Handles special characters, powerful filters</td>
                                <td>Spawns process per file</td>
                            </tr>
                            <tr>
                                <td><code>find | while</code></td>
                                <td>Complex processing per file</td>
                                <td>Subshell variable scope</td>
                            </tr>
                            <tr>
                                <td>Recursive function</td>
                                <td>Full control, custom logic</td>
                                <td>More code, stack limits</td>
                            </tr>
                            <tr>
                                <td><code>globstar **</code></td>
                                <td>Simple syntax, readable</td>
                                <td>Bash 4+ only, less flexible</td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="tip-box">
                        <strong>Performance Tip:</strong> For many files, use <code>find ... -exec command {} +</code> (plus instead of semicolon) to batch files into fewer command executions.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Advanced find -->
                    <h2>Advanced find Operations</h2>
                    <p>The <code>find</code> command is incredibly powerful. Master these patterns for complex file operations.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/files-directories-find.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-find" />
                    </jsp:include>

                    <h3>Essential find Expressions</h3>
                    <pre><code class="language-bash"># By type
find . -type f           # Regular files only
find . -type d           # Directories only
find . -type l           # Symbolic links

# By name (supports globs)
find . -name "*.log"     # Case-sensitive match
find . -iname "*.LOG"    # Case-insensitive

# By size
find . -size +100M       # Larger than 100MB
find . -size -1k         # Smaller than 1KB
find . -empty            # Zero-size files/dirs

# By time (days)
find . -mtime -7         # Modified in last 7 days
find . -atime +30        # Accessed over 30 days ago
find . -newer ref.txt    # Newer than ref.txt

# By permissions
find . -perm 755         # Exact permissions
find . -perm -u+x        # User executable

# Combining expressions
find . -type f -name "*.sh" -executable
find . \( -name "*.c" -o -name "*.h" \)
find . -type f ! -name "*.bak"</code></pre>

                    <h3>find Actions</h3>
                    <pre><code class="language-bash"># Print (default)
find . -name "*.txt" -print

# Execute command for each
find . -name "*.sh" -exec chmod +x {} \;

# Execute with confirmation
find . -name "*.bak" -ok rm {} \;

# Print with format
find . -type f -printf "%p %s bytes\n"

# Delete (careful!)
find . -name "*.tmp" -delete

# Batch execution (more efficient)
find . -name "*.c" -exec cat {} +</code></pre>

                    <div class="warning-box">
                        <strong>Caution:</strong> Always test <code>find</code> commands with <code>-print</code> before using <code>-delete</code> or destructive <code>-exec</code> actions. The deletion is immediate and permanent!
                    </div>

                    <!-- Practical Patterns -->
                    <h2>Practical Directory Patterns</h2>

                    <pre><code class="language-bash"># Find and delete empty directories
find . -type d -empty -delete

# Find large files
find . -type f -size +100M -exec ls -lh {} \;

# Find recently modified files
find . -type f -mmin -60  # Modified in last 60 minutes

# Find and replace in files
find . -name "*.txt" -exec sed -i 's/old/new/g' {} \;

# Find files not matching pattern
find . -type f ! -name "*.md" ! -name "*.txt"

# Count files by extension
find . -type f -name "*.js" | wc -l

# Find duplicate files by size
find . -type f -exec ls -l {} \; | awk '{print \$5}' | sort | uniq -d

# Safe recursive delete with confirmation
find_delete() {
    find "\$1" -name "\$2" -print
    read -p "Delete these files? [y/N] " confirm
    [[ "\$confirm" == [yY] ]] && find "\$1" -name "\$2" -delete
}

# Process files in parallel (GNU parallel)
# find . -name "*.jpg" | parallel convert {} -resize 50% resized/{}</code></pre>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Forgetting to quote glob patterns</h4>
                        <pre><code class="language-bash"># Wrong - shell expands glob before find runs
find . -name *.txt

# Correct - find receives the pattern
find . -name "*.txt"</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Using semicolon without backslash</h4>
                        <pre><code class="language-bash"># Wrong - shell interprets semicolon
find . -exec echo {} ;

# Correct - escape or quote
find . -exec echo {} \;
find . -exec echo {} ';'</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Iterating with ls output</h4>
                        <pre><code class="language-bash"># Wrong - breaks on spaces/special chars
for f in \$(ls); do echo "\$f"; done

# Correct - use glob directly
for f in *; do echo "\$f"; done

# Or use find with null separator
find . -print0 | while IFS= read -r -d '' f; do
    echo "\$f"
done</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Directory Statistics</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a script that generates directory statistics!</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Count total files and directories</li>
                            <li>Calculate total size</li>
                            <li>Find largest file</li>
                            <li>Count files by extension</li>
                            <li>Show most recently modified files</li>
                        </ul>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-bash">#!/bin/bash
# Directory Statistics Tool

dir_stats() {
    local dir="\${1:-.}"

    echo "=== Directory Statistics: \$dir ==="
    echo ""

    # Count files and directories
    local files=\$(find "\$dir" -type f | wc -l)
    local dirs=\$(find "\$dir" -type d | wc -l)
    echo "Files: \$files"
    echo "Directories: \$dirs"
    echo ""

    # Total size
    local size=\$(du -sh "\$dir" 2>/dev/null | cut -f1)
    echo "Total size: \$size"
    echo ""

    # Largest files
    echo "Top 5 largest files:"
    find "\$dir" -type f -exec ls -lh {} \; 2>/dev/null | \
        sort -k5 -hr | head -5 | \
        awk '{print "  " \$5 " " \$9}'
    echo ""

    # Files by extension
    echo "Files by extension:"
    find "\$dir" -type f -name "*.*" | \
        sed 's/.*\.//' | sort | uniq -c | \
        sort -rn | head -10 | \
        awk '{print "  " \$1 " ." \$2}'
    echo ""

    # Recently modified
    echo "Recently modified (last 24h):"
    find "\$dir" -type f -mtime -1 -exec ls -lh {} \; 2>/dev/null | \
        head -5 | awk '{print "  " \$6 " " \$7 " " \$8 " " \$9}'
}

# Run on current directory or specified path
dir_stats "\${1:-.}"</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Basic Ops:</strong> Use <code>ls</code>, <code>cd</code>, <code>pwd</code>, <code>mkdir -p</code> for fundamentals</li>
                            <li><strong>Iteration:</strong> Use globs (<code>for f in *</code>) for simple cases</li>
                            <li><strong>Recursive:</strong> Use <code>find</code> for recursive processing with filters</li>
                            <li><strong>globstar:</strong> Enable with <code>shopt -s globstar</code> for <code>**</code> patterns</li>
                            <li><strong>find Actions:</strong> Use <code>-exec {} \;</code> for per-file, <code>{} +</code> for batched</li>
                            <li><strong>Safety:</strong> Test destructive commands with <code>-print</code> first</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Congratulations on completing the File Operations module! You now have powerful skills for reading, writing, testing, and navigating files and directories. Next, explore <strong>Process Management</strong> to learn about job control, background processes, and signal handling!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="files-testing.jsp" />
                    <jsp:param name="prevTitle" value="File Testing" />
                    <jsp:param name="nextLink" value="advanced-regex.jsp" />
                    <jsp:param name="nextTitle" value="Regular Expressions" />
                    <jsp:param name="currentLessonId" value="files-directories" />
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
