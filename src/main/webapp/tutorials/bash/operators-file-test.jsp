<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "operators-file-test");
   request.setAttribute("currentModule", "Operators & Arithmetic"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>File Test Operators - Bash Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn Bash file test operators to check file existence, permissions, and types. Master -f, -d, -e, -r, -w, -x, -s, -z, -n and file comparison operators in shell scripts.">
    <meta name="keywords"
        content="bash file test, bash -f -d -e, bash file exists, bash check file, bash permissions, bash file comparison, bash operators">

    <meta property="og:type" content="article">
    <meta property="og:title" content="File Test Operators - Bash Tutorial">
    <meta property="og:description" content="Master Bash file test operators to check existence, permissions, types, and compare files.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/operators-file-test.jsp">
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
        "name": "Bash File Test Operators",
        "description": "Learn Bash file test operators to check file existence, permissions, types, and compare files.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["File existence tests", "Permission tests (-r, -w, -x)", "File type tests (-f, -d, -L)", "Size tests (-s)", "File comparison (-nt, -ot, -ef)", "String tests (-z, -n)"],
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

<body class="tutorial-body no-preview" data-lesson="operators-file-test">
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
                    <span>File Test Operators</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">File Test Operators</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~20 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">File test operators are essential for any script that works with files and directories. They let you check if files exist, verify permissions, determine file types, and compare files. These operators are used constantly in real-world shell scripts for validation and conditional logic!</p>

                    <!-- Section 1: Existence and Permission Tests -->
                    <h2>Existence and Permission Tests</h2>
                    <p>The most common file tests check whether files exist and what permissions they have. These are the foundation of defensive scripting!</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/operators-file-test.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-filetest" />
                    </jsp:include>

                    <h3>Existence Operators</h3>
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
                                <td><code>-e</code></td>
                                <td>File exists (any type)</td>
                                <td><code>[[ -e "\$file" ]]</code></td>
                            </tr>
                            <tr>
                                <td><code>-f</code></td>
                                <td>Exists and is a regular file</td>
                                <td><code>[[ -f "\$file" ]]</code></td>
                            </tr>
                            <tr>
                                <td><code>-d</code></td>
                                <td>Exists and is a directory</td>
                                <td><code>[[ -d "\$dir" ]]</code></td>
                            </tr>
                            <tr>
                                <td><code>-L</code> or <code>-h</code></td>
                                <td>Exists and is a symbolic link</td>
                                <td><code>[[ -L "\$link" ]]</code></td>
                            </tr>
                        </tbody>
                    </table>

                    <h3>Permission Operators</h3>
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
                                <td><code>-r</code></td>
                                <td>File is readable</td>
                                <td><code>[[ -r "\$file" ]]</code></td>
                            </tr>
                            <tr>
                                <td><code>-w</code></td>
                                <td>File is writable</td>
                                <td><code>[[ -w "\$file" ]]</code></td>
                            </tr>
                            <tr>
                                <td><code>-x</code></td>
                                <td>File is executable</td>
                                <td><code>[[ -x "\$script" ]]</code></td>
                            </tr>
                            <tr>
                                <td><code>-s</code></td>
                                <td>File exists and size > 0</td>
                                <td><code>[[ -s "\$file" ]]</code></td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="info-box">
                        <strong>Best Practice:</strong> Always check if a file exists before trying to read or modify it. Use <code>[[ -f "\$file" ]] && cat "\$file"</code> to avoid errors when the file doesn't exist.
                    </div>

                    <!-- Section 2: File Type Tests -->
                    <h2>File Type Tests</h2>
                    <p>Beyond regular files and directories, Unix has several special file types. These operators help you identify them.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/operators-file-test-types.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-types" />
                    </jsp:include>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Operator</th>
                                <th>Description</th>
                                <th>Common Examples</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>-f</code></td>
                                <td>Regular file</td>
                                <td>Scripts, text files, configs</td>
                            </tr>
                            <tr>
                                <td><code>-d</code></td>
                                <td>Directory</td>
                                <td>/home, /tmp, /var</td>
                            </tr>
                            <tr>
                                <td><code>-L</code></td>
                                <td>Symbolic link</td>
                                <td>/usr/bin/python -> python3</td>
                            </tr>
                            <tr>
                                <td><code>-b</code></td>
                                <td>Block device</td>
                                <td>/dev/sda, /dev/nvme0n1</td>
                            </tr>
                            <tr>
                                <td><code>-c</code></td>
                                <td>Character device</td>
                                <td>/dev/null, /dev/tty</td>
                            </tr>
                            <tr>
                                <td><code>-p</code></td>
                                <td>Named pipe (FIFO)</td>
                                <td>Inter-process communication</td>
                            </tr>
                            <tr>
                                <td><code>-S</code></td>
                                <td>Socket</td>
                                <td>/var/run/docker.sock</td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> The <code>-f</code> operator follows symbolic links. To check if something is a symlink regardless of what it points to, use <code>-L</code>. To check if a symlink points to a valid target, combine them: <code>[[ -L "\$link" && -e "\$link" ]]</code>.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: File Comparison -->
                    <h2>File Comparison Operators</h2>
                    <p>These operators compare files by modification time and identity (same inode). Perfect for backup scripts and synchronization!</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/operators-file-test-compare.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-compare" />
                    </jsp:include>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Operator</th>
                                <th>Description</th>
                                <th>Use Case</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>file1 -nt file2</code></td>
                                <td>file1 is newer than file2</td>
                                <td>Backup/sync decisions</td>
                            </tr>
                            <tr>
                                <td><code>file1 -ot file2</code></td>
                                <td>file1 is older than file2</td>
                                <td>Cache invalidation</td>
                            </tr>
                            <tr>
                                <td><code>file1 -ef file2</code></td>
                                <td>Same file (same device & inode)</td>
                                <td>Hard link detection</td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="warning-box">
                        <strong>Caution:</strong> The <code>-nt</code> and <code>-ot</code> operators return false if either file doesn't exist. Always check existence first with <code>-e</code> if you're not sure the files exist!
                    </div>

                    <!-- Section 4: String Tests -->
                    <h2>String Length Tests</h2>
                    <p>While not strictly file operators, <code>-z</code> and <code>-n</code> are often used alongside file tests to check variable values.</p>

                    <pre><code class="language-bash"># -z: String is zero length (empty)
filename=""
if [[ -z "\$filename" ]]; then
    echo "No filename provided"
fi

# -n: String is non-zero length (not empty)
filename="script.sh"
if [[ -n "\$filename" ]]; then
    echo "Filename: \$filename"
fi

# Common pattern: validate before using
if [[ -n "\$1" && -f "\$1" ]]; then
    echo "Processing file: \$1"
else
    echo "Please provide a valid filename"
fi</code></pre>

                    <div class="info-box">
                        <strong>Remember:</strong>
                        <ul>
                            <li><code>-z</code> = <strong>Z</strong>ero length (empty string)</li>
                            <li><code>-n</code> = <strong>N</strong>on-zero length (has content)</li>
                        </ul>
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Forgetting to quote the filename</h4>
                        <pre><code class="language-bash"># Wrong - breaks on spaces or special chars
file="my file.txt"
[[ -f \$file ]]   # Error!

# Correct - always quote
[[ -f "\$file" ]]  # Works correctly</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Confusing -e and -f</h4>
                        <pre><code class="language-bash"># -e returns true for directories too
[[ -e "/tmp" ]]  # True (exists)
[[ -f "/tmp" ]]  # False (not a regular file)

# Use -f when you specifically need a regular file
# Use -e when any file type is acceptable</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Not checking existence before operations</h4>
                        <pre><code class="language-bash"># Wrong - may fail silently or with error
cat "\$config_file"

# Correct - check first
if [[ -f "\$config_file" ]]; then
    cat "\$config_file"
else
    echo "Config file not found!"
    exit 1
fi</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Using -nt/-ot without checking existence</h4>
                        <pre><code class="language-bash"># Risky - returns false if file doesn't exist
[[ "\$backup" -nt "\$source" ]]

# Safer - verify both exist
if [[ -f "\$backup" && -f "\$source" ]]; then
    [[ "\$backup" -nt "\$source" ]] && echo "Backup is current"
fi</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: File Validation Script</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a comprehensive file validation script!</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Check if a file path was provided (not empty)</li>
                            <li>Verify the file exists</li>
                            <li>Check if it's a regular file (not a directory)</li>
                            <li>Verify it's readable</li>
                            <li>Check if it's not empty (size > 0)</li>
                            <li>Report all findings</li>
                        </ul>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-bash">#!/bin/bash
# File Validation Script

file="\$1"  # Get filename from argument

echo "=== File Validation Report ==="
echo ""

# Check 1: Path provided?
if [[ -z "\$file" ]]; then
    echo "ERROR: No file path provided"
    echo "Usage: \$0 <filename>"
    exit 1
fi
echo "File: \$file"
echo ""

# Check 2: Exists?
echo -n "Exists: "
if [[ -e "\$file" ]]; then
    echo "YES"
else
    echo "NO - File not found!"
    exit 1
fi

# Check 3: Regular file?
echo -n "Regular file: "
if [[ -f "\$file" ]]; then
    echo "YES"
else
    echo "NO (might be directory or special file)"
fi

# Check 4: Readable?
echo -n "Readable: "
if [[ -r "\$file" ]]; then
    echo "YES"
else
    echo "NO - Permission denied"
fi

# Check 5: Non-empty?
echo -n "Has content: "
if [[ -s "\$file" ]]; then
    echo "YES (size > 0)"
else
    echo "NO (empty file)"
fi

# Check 6: Writable?
echo -n "Writable: "
if [[ -w "\$file" ]]; then
    echo "YES"
else
    echo "NO"
fi

echo ""
echo "Validation complete!"</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Existence:</strong> <code>-e</code> (any), <code>-f</code> (file), <code>-d</code> (directory), <code>-L</code> (symlink)</li>
                            <li><strong>Permissions:</strong> <code>-r</code> (readable), <code>-w</code> (writable), <code>-x</code> (executable)</li>
                            <li><strong>Size:</strong> <code>-s</code> (size > 0)</li>
                            <li><strong>Types:</strong> <code>-b</code> (block), <code>-c</code> (char), <code>-p</code> (pipe), <code>-S</code> (socket)</li>
                            <li><strong>Comparison:</strong> <code>-nt</code> (newer), <code>-ot</code> (older), <code>-ef</code> (same file)</li>
                            <li><strong>Strings:</strong> <code>-z</code> (empty), <code>-n</code> (not empty)</li>
                            <li><strong>Always Quote:</strong> Use <code>[[ -f "\$file" ]]</code> to handle spaces and special characters</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Congratulations! You've completed the <strong>Operators & Arithmetic</strong> module. You now know how to perform calculations, compare values, combine conditions, and test files. Next, we'll dive into <strong>Control Flow</strong> with <code>if</code> statements, <code>case</code> statements, and loops to put all these operators to work!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="operators-logical.jsp" />
                    <jsp:param name="prevTitle" value="Logical Operators" />
                    <jsp:param name="nextLink" value="control-if.jsp" />
                    <jsp:param name="nextTitle" value="If Statements" />
                    <jsp:param name="currentLessonId" value="operators-file-test" />
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
