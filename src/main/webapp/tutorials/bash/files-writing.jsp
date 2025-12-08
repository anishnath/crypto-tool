<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "files-writing");
   request.setAttribute("currentModule", "File Operations"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>File Writing - Bash Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn how to write files in Bash using echo, printf, redirection, and here documents. Master safe file writing techniques and formatted output in shell scripts.">
    <meta name="keywords"
        content="bash write file, bash echo, bash printf, bash redirection, bash here document, shell script file writing, bash append file">

    <meta property="og:type" content="article">
    <meta property="og:title" content="File Writing - Bash Tutorial">
    <meta property="og:description" content="Master file writing techniques in Bash including echo, printf, redirection, and safe writing patterns.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/files-writing.jsp">
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
        "name": "Bash File Writing",
        "description": "Learn how to write files in Bash using echo, printf, redirection, and here documents with safe writing techniques.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["echo command", "printf formatting", "Output redirection", "Here documents", "Atomic writes", "File appending", "Safe writing patterns"],
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

<body class="tutorial-body no-preview" data-lesson="files-writing">
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
                    <span>File Writing</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">File Writing</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~20 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Writing files is essential for creating logs, configuration files, reports, and data exports. Bash provides multiple methods for file writing, from simple <code>echo</code> to formatted <code>printf</code> output. You'll also learn safe writing techniques to prevent data loss!</p>

                    <!-- Section 1: Basic File Writing -->
                    <h2>Basic File Writing Methods</h2>
                    <p>The most common ways to write files are using <code>echo</code>, <code>printf</code>, and here documents with output redirection.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/files-writing.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-writing" />
                    </jsp:include>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Method</th>
                                <th>Description</th>
                                <th>Example</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>></code></td>
                                <td>Overwrite file (create if not exists)</td>
                                <td><code>echo "text" > file.txt</code></td>
                            </tr>
                            <tr>
                                <td><code>>></code></td>
                                <td>Append to file</td>
                                <td><code>echo "text" >> file.txt</code></td>
                            </tr>
                            <tr>
                                <td><code>cat > file << EOF</code></td>
                                <td>Here document (multi-line)</td>
                                <td><code>cat > config.txt << EOF ... EOF</code></td>
                            </tr>
                            <tr>
                                <td><code>printf</code></td>
                                <td>Formatted output</td>
                                <td><code>printf "%s: %d\n" "Count" 5 > file</code></td>
                            </tr>
                            <tr>
                                <td><code>tee</code></td>
                                <td>Write to file AND stdout</td>
                                <td><code>echo "text" | tee file.txt</code></td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="info-box">
                        <strong>Overwrite vs Append:</strong>
                        <ul>
                            <li><code>></code> - Creates new file or <strong>overwrites</strong> existing content (destructive!)</li>
                            <li><code>>></code> - Creates new file or <strong>appends</strong> to existing content (safe for logs)</li>
                        </ul>
                    </div>

                    <!-- Section 2: Printf Formatting -->
                    <h2>Printf for Formatted Output</h2>
                    <p>The <code>printf</code> command offers precise control over output formatting, making it perfect for tables, reports, and structured data.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/files-writing-printf.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-printf" />
                    </jsp:include>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Format</th>
                                <th>Description</th>
                                <th>Example</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>%s</code></td>
                                <td>String</td>
                                <td><code>printf "%s" "hello"</code></td>
                            </tr>
                            <tr>
                                <td><code>%d</code></td>
                                <td>Integer</td>
                                <td><code>printf "%d" 42</code></td>
                            </tr>
                            <tr>
                                <td><code>%f</code> / <code>%.2f</code></td>
                                <td>Float / with precision</td>
                                <td><code>printf "%.2f" 3.14159</code></td>
                            </tr>
                            <tr>
                                <td><code>%10s</code></td>
                                <td>Right-padded (10 chars)</td>
                                <td><code>printf "%10s" "hi"</code></td>
                            </tr>
                            <tr>
                                <td><code>%-10s</code></td>
                                <td>Left-padded (10 chars)</td>
                                <td><code>printf "%-10s" "hi"</code></td>
                            </tr>
                            <tr>
                                <td><code>%05d</code></td>
                                <td>Zero-padded integer</td>
                                <td><code>printf "%05d" 42</code> → <code>00042</code></td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Use <code>printf</code> instead of <code>echo</code> when you need consistent behavior across systems. <code>echo</code> behaves differently on various platforms, while <code>printf</code> is standardized.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Safe Writing Techniques -->
                    <h2>Safe File Writing Techniques</h2>
                    <p>Production scripts need robust file writing that handles errors and prevents data loss. Learn professional patterns for safe file operations.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/files-writing-safe.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-safe" />
                    </jsp:include>

                    <h3>Safe Writing Patterns</h3>
                    <pre><code class="language-bash"># 1. Atomic write with temp file
temp=\$(mktemp)
echo "content" > "\$temp" && mv "\$temp" "target.txt"

# 2. Write with backup
cp "file.txt" "file.txt.bak"
echo "new content" > "file.txt"

# 3. Check write success
if echo "data" > "file.txt"; then
    echo "Write succeeded"
else
    echo "Write failed!" >&2
    exit 1
fi

# 4. noclobber - prevent accidental overwrite
set -o noclobber
echo "test" > existing.txt  # Fails if exists
echo "test" >| existing.txt # Force overwrite

# 5. Write to stderr for errors
echo "Error: Something wrong" >&2</code></pre>

                    <div class="warning-box">
                        <strong>Caution:</strong> Always be careful with <code>></code> redirection - it destroys existing file content immediately! Consider using <code>set -o noclobber</code> in interactive shells, or always create backups before overwriting important files.
                    </div>

                    <!-- Section 4: Here Documents -->
                    <h2>Multi-line Writing with Here Documents</h2>
                    <p>Here documents are perfect for writing multi-line content like configuration files, scripts, or templates.</p>

                    <pre><code class="language-bash"># Basic here document
cat > config.txt << 'EOF'
[settings]
debug = true
port = 8080
host = localhost
EOF

# With variable expansion (unquoted EOF)
name="MyApp"
version="1.0"
cat > config.txt << EOF
app_name=\$name
app_version=\$version
generated=\$(date)
EOF

# Append with here document
cat >> log.txt << EOF
[\$(date)] New entry added
EOF

# Here string (single line)
cat <<< "Single line content" > file.txt</code></pre>

                    <div class="info-box">
                        <strong>Quoted vs Unquoted Delimiter:</strong>
                        <ul>
                            <li><code><< 'EOF'</code> - No variable expansion (literal text)</li>
                            <li><code><< EOF</code> - Variables and commands are expanded</li>
                        </ul>
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Accidentally overwriting important files</h4>
                        <pre><code class="language-bash"># Dangerous - overwrites without warning
echo "test" > /etc/important.conf

# Safer - check first
if [[ -f "important.conf" ]]; then
    cp "important.conf" "important.conf.bak"
fi
echo "test" > "important.conf"</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Forgetting quotes in filenames</h4>
                        <pre><code class="language-bash"># Wrong - fails with spaces in filename
echo "data" > \$filename

# Correct - always quote
echo "data" > "\$filename"</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Not checking write permissions</h4>
                        <pre><code class="language-bash"># Wrong - might fail silently
echo "log entry" >> /var/log/app.log

# Correct - check first
if [[ -w "/var/log/app.log" ]]; then
    echo "log entry" >> "/var/log/app.log"
else
    echo "Cannot write to log file" >&2
fi</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Using echo -e inconsistently</h4>
                        <pre><code class="language-bash"># Inconsistent - echo -e behavior varies by system
echo -e "line1\nline2"

# Consistent - use printf
printf "line1\nline2\n"

# Or use \$'...' syntax
echo \$'line1\nline2'</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Log File Generator</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a script that generates a formatted log file!</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Create a log file with a header (app name, generated date)</li>
                            <li>Add several timestamped log entries</li>
                            <li>Create a summary section with line count</li>
                            <li>Use printf for aligned columns</li>
                        </ul>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-bash">#!/bin/bash
# Log File Generator

log_file="/tmp/app.log"

# Write header
cat > "\$log_file" << EOF
========================================
Application Log
Generated: \$(date '+%Y-%m-%d %H:%M:%S')
========================================

EOF

# Add timestamped entries using printf
{
    printf "%-20s %-8s %s\n" "TIMESTAMP" "LEVEL" "MESSAGE"
    printf "%-20s %-8s %s\n" "--------------------" "--------" "------------------------"
    printf "%-20s %-8s %s\n" "\$(date '+%H:%M:%S.%3N')" "INFO" "Application started"
    printf "%-20s %-8s %s\n" "\$(date '+%H:%M:%S.%3N')" "DEBUG" "Loading configuration"
    printf "%-20s %-8s %s\n" "\$(date '+%H:%M:%S.%3N')" "INFO" "Connected to database"
    printf "%-20s %-8s %s\n" "\$(date '+%H:%M:%S.%3N')" "WARN" "Cache miss detected"
    printf "%-20s %-8s %s\n" "\$(date '+%H:%M:%S.%3N')" "INFO" "Request processed"
} >> "\$log_file"

# Add summary
{
    echo ""
    echo "========================================"
    echo "Summary"
    echo "Total entries: \$(grep -c "^[0-9]" "\$log_file")"
    echo "========================================"
} >> "\$log_file"

echo "Log file created:"
cat "\$log_file"

rm -f "\$log_file"</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Overwrite:</strong> <code>></code> creates or overwrites file</li>
                            <li><strong>Append:</strong> <code>>></code> adds to existing file</li>
                            <li><strong>printf:</strong> Formatted output with precise control (<code>%s</code>, <code>%d</code>, <code>%.2f</code>)</li>
                            <li><strong>Here Document:</strong> Multi-line content with <code><< EOF ... EOF</code></li>
                            <li><strong>tee:</strong> Write to file AND display (<code>echo | tee file</code>)</li>
                            <li><strong>Atomic Write:</strong> Use temp file then <code>mv</code> for safety</li>
                            <li><strong>noclobber:</strong> <code>set -o noclobber</code> prevents accidental overwrites</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you can read and write files, let's learn about <strong>File Manipulation</strong>. You'll master copying, moving, deleting files, and working with file permissions using <code>cp</code>, <code>mv</code>, <code>rm</code>, <code>chmod</code>, and more!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="files-reading.jsp" />
                    <jsp:param name="prevTitle" value="File Reading" />
                    <jsp:param name="nextLink" value="files-manipulation.jsp" />
                    <jsp:param name="nextTitle" value="File Manipulation" />
                    <jsp:param name="currentLessonId" value="files-writing" />
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
