<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "files-reading");
   request.setAttribute("currentModule", "File Operations"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>File Reading - Bash Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn how to read files in Bash using cat, while read loops, head, tail, and field parsing. Master line-by-line processing and CSV parsing in shell scripts.">
    <meta name="keywords"
        content="bash read file, bash while read, bash cat, bash head tail, bash parse csv, bash IFS, shell script file reading">

    <meta property="og:type" content="article">
    <meta property="og:title" content="File Reading - Bash Tutorial">
    <meta property="og:description" content="Master file reading techniques in Bash including line-by-line processing and field parsing.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/files-reading.jsp">
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
        "name": "Bash File Reading",
        "description": "Learn how to read files in Bash using various methods including cat, while read loops, head, tail, and field parsing.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["cat command", "while read loop", "head and tail", "readarray/mapfile", "IFS field parsing", "CSV parsing", "Line-by-line processing"],
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

<body class="tutorial-body no-preview" data-lesson="files-reading">
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
                    <span>File Reading</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">File Reading</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Reading files is one of the most common operations in shell scripting. Whether you're processing logs, parsing configuration files, or transforming data, Bash provides multiple powerful methods for reading file content. In this lesson, you'll master techniques from simple reads to complex field parsing!</p>

                    <!-- Section 1: Basic File Reading -->
                    <h2>Basic File Reading Methods</h2>
                    <p>Bash offers several ways to read file content. The right choice depends on whether you need the entire file, line-by-line processing, or specific portions.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/files-reading.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-reading" />
                    </jsp:include>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Method</th>
                                <th>Use Case</th>
                                <th>Example</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>cat file</code></td>
                                <td>Read entire file at once</td>
                                <td><code>content=\$(cat file.txt)</code></td>
                            </tr>
                            <tr>
                                <td><code>while read</code></td>
                                <td>Process line by line</td>
                                <td><code>while read line; do ... done < file</code></td>
                            </tr>
                            <tr>
                                <td><code>mapfile</code></td>
                                <td>Read into array</td>
                                <td><code>mapfile -t arr < file</code></td>
                            </tr>
                            <tr>
                                <td><code>< file</code></td>
                                <td>Input redirection</td>
                                <td><code>command < file.txt</code></td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="info-box">
                        <strong>The while read Pattern:</strong> The most common pattern for processing files line by line is:
                        <pre><code class="language-bash">while IFS= read -r line; do
    echo "\$line"
done < file.txt</code></pre>
                        <ul>
                            <li><code>IFS=</code> - Preserves leading/trailing whitespace</li>
                            <li><code>-r</code> - Prevents backslash interpretation</li>
                        </ul>
                    </div>

                    <!-- Section 2: Partial File Reading -->
                    <h2>Reading Parts of Files</h2>
                    <p>Often you don't need the entire file. Use <code>head</code>, <code>tail</code>, and <code>sed</code> to extract specific portions efficiently.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/files-reading-partial.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-partial" />
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
                                <td><code>head -n N</code></td>
                                <td>First N lines</td>
                                <td><code>head -n 10 file.txt</code></td>
                            </tr>
                            <tr>
                                <td><code>tail -n N</code></td>
                                <td>Last N lines</td>
                                <td><code>tail -n 10 file.txt</code></td>
                            </tr>
                            <tr>
                                <td><code>tail -n +N</code></td>
                                <td>From line N to end</td>
                                <td><code>tail -n +5 file.txt</code></td>
                            </tr>
                            <tr>
                                <td><code>tail -f</code></td>
                                <td>Follow (watch for new content)</td>
                                <td><code>tail -f /var/log/syslog</code></td>
                            </tr>
                            <tr>
                                <td><code>sed -n 'N,Mp'</code></td>
                                <td>Lines N through M</td>
                                <td><code>sed -n '5,10p' file.txt</code></td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Use <code>tail -f</code> for real-time log monitoring. Combine with <code>grep</code> to filter: <code>tail -f /var/log/syslog | grep error</code>
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Field Parsing -->
                    <h2>Parsing Fields from Files</h2>
                    <p>Many files are structured with delimiters (CSV, colon-separated, etc.). Learn to parse these efficiently using <code>IFS</code>, <code>cut</code>, and <code>awk</code>.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/files-reading-fields.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-fields" />
                    </jsp:include>

                    <h3>IFS (Internal Field Separator)</h3>
                    <pre><code class="language-bash"># Parse comma-separated values
while IFS=, read -r field1 field2 field3; do
    echo "Fields: \$field1, \$field2, \$field3"
done < data.csv

# Parse colon-separated (like /etc/passwd)
while IFS=: read -r user pass uid gid desc home shell; do
    echo "User \$user has shell \$shell"
done < /etc/passwd</code></pre>

                    <div class="info-box">
                        <strong>Field Parsing Tools:</strong>
                        <ul>
                            <li><code>IFS=</code> - Set delimiter for <code>read</code></li>
                            <li><code>cut -d',' -f1</code> - Extract specific field</li>
                            <li><code>awk -F',' '{print \$1}'</code> - More powerful field extraction</li>
                            <li><code>tr ',' '\n'</code> - Transform delimiters</li>
                        </ul>
                    </div>

                    <!-- Section 4: Reading from Other Sources -->
                    <h2>Reading from Other Sources</h2>
                    <p>Beyond regular files, you can read from command output, URLs, and special files.</p>

                    <pre><code class="language-bash"># Read from command output (process substitution)
while read -r line; do
    echo "Process: \$line"
done < <(ps aux | head -5)

# Read multiple files
for file in *.txt; do
    while read -r line; do
        echo "[\$file] \$line"
    done < "\$file"
done

# Read from here document
while read -r line; do
    echo "Config: \$line"
done <<EOF
setting1=value1
setting2=value2
EOF

# Read specific bytes
dd if=file.bin bs=1 count=10 2>/dev/null | xxd</code></pre>

                    <div class="warning-box">
                        <strong>Caution:</strong> When reading binary files or files with special characters, always use <code>read -r</code> to prevent backslash interpretation. For binary data, consider using <code>dd</code> or <code>xxd</code> instead of text-based tools.
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Forgetting -r in read</h4>
                        <pre><code class="language-bash"># Wrong - backslashes are interpreted
while read line; do echo "\$line"; done

# Correct - backslashes preserved
while IFS= read -r line; do echo "\$line"; done</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Losing whitespace</h4>
                        <pre><code class="language-bash"># Wrong - leading/trailing spaces lost
while read line; do echo "\$line"; done

# Correct - IFS= preserves whitespace
while IFS= read -r line; do echo "\$line"; done</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Reading file in subshell (variable scope)</h4>
                        <pre><code class="language-bash"># Wrong - count stays 0 (subshell)
count=0
cat file.txt | while read line; do ((count++)); done
echo "\$count"  # Still 0!

# Correct - no subshell with redirection
count=0
while read -r line; do ((count++)); done < file.txt
echo "\$count"  # Correct count</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Not checking if file exists</h4>
                        <pre><code class="language-bash"># Wrong - error if file doesn't exist
while read -r line; do echo "\$line"; done < missing.txt

# Correct - check first
if [[ -f "file.txt" ]]; then
    while read -r line; do echo "\$line"; done < "file.txt"
else
    echo "File not found!"
fi</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Log File Analyzer</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a script that analyzes a log file!</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Count total number of lines</li>
                            <li>Count lines containing "error" (case-insensitive)</li>
                            <li>Display the first and last 3 lines</li>
                            <li>Parse and display unique IP addresses (first field)</li>
                        </ul>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-bash">#!/bin/bash
# Log File Analyzer

# Create sample log file
log_file="/tmp/access.log"
cat > "\$log_file" << 'EOF'
192.168.1.1 - - [01/Jan/2024] "GET /index.html" 200
192.168.1.2 - - [01/Jan/2024] "GET /error.html" 404
192.168.1.1 - - [01/Jan/2024] "POST /api" 500 Error
10.0.0.1 - - [01/Jan/2024] "GET /about.html" 200
192.168.1.3 - - [01/Jan/2024] "GET /contact" 200
10.0.0.1 - - [01/Jan/2024] "GET /error" 500 Error
EOF

echo "=== Log File Analysis ==="
echo "File: \$log_file"
echo ""

# Count total lines
total=\$(wc -l < "\$log_file")
echo "Total lines: \$total"

# Count error lines (case-insensitive)
errors=\$(grep -ic "error" "\$log_file")
echo "Lines with 'error': \$errors"
echo ""

# First and last 3 lines
echo "--- First 3 lines ---"
head -n 3 "\$log_file"
echo ""
echo "--- Last 3 lines ---"
tail -n 3 "\$log_file"
echo ""

# Unique IPs (first field)
echo "--- Unique IP Addresses ---"
cut -d' ' -f1 "\$log_file" | sort -u

# Cleanup
rm -f "\$log_file"</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>cat:</strong> Read entire file into variable or output</li>
                            <li><strong>while read:</strong> Process file line by line (<code>while IFS= read -r line</code>)</li>
                            <li><strong>mapfile:</strong> Read file into array (<code>mapfile -t arr < file</code>)</li>
                            <li><strong>head/tail:</strong> Read first/last N lines, or follow file changes</li>
                            <li><strong>IFS:</strong> Set field delimiter for parsing structured data</li>
                            <li><strong>cut/awk:</strong> Extract specific fields from delimited data</li>
                            <li><strong>Always use:</strong> <code>IFS= read -r</code> to preserve whitespace and backslashes</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now that you can read files, let's learn how to <strong>write files</strong>. You'll discover how to create files, append content, use <code>printf</code> for formatted output, and safely write to files without data loss!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="io-process-substitution.jsp" />
                    <jsp:param name="prevTitle" value="Process Substitution" />
                    <jsp:param name="nextLink" value="files-writing.jsp" />
                    <jsp:param name="nextTitle" value="File Writing" />
                    <jsp:param name="currentLessonId" value="files-reading" />
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
