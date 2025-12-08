<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "files-manipulation");
   request.setAttribute("currentModule", "File Operations"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>File Manipulation - Bash Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn Bash file manipulation with cp, mv, rm, chmod, and find. Master copying, moving, deleting files, changing permissions, and finding files in shell scripts.">
    <meta name="keywords"
        content="bash cp mv rm, bash chmod, bash find, bash file permissions, bash copy file, bash move file, bash delete file">

    <meta property="og:type" content="article">
    <meta property="og:title" content="File Manipulation - Bash Tutorial">
    <meta property="og:description" content="Master file manipulation in Bash with cp, mv, rm, chmod, and find commands.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/files-manipulation.jsp">
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
        "name": "Bash File Manipulation",
        "description": "Learn Bash file manipulation with cp, mv, rm, chmod, and find commands for comprehensive file management.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["cp command", "mv command", "rm command", "chmod permissions", "find command", "File permissions", "touch command"],
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

<body class="tutorial-body no-preview" data-lesson="files-manipulation">
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
                    <span>File Manipulation</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">File Manipulation</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">File manipulation is at the heart of shell scripting. Whether you're organizing files, setting permissions, or finding specific files, Bash provides powerful commands for every task. In this lesson, you'll master <code>cp</code>, <code>mv</code>, <code>rm</code>, <code>chmod</code>, and the incredibly versatile <code>find</code> command!</p>

                    <!-- Section 1: Basic File Operations -->
                    <h2>Basic File Operations: cp, mv, rm</h2>
                    <p>The fundamental file manipulation commands let you copy, move, rename, and delete files and directories.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/files-manipulation.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-manipulation" />
                    </jsp:include>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Command</th>
                                <th>Description</th>
                                <th>Common Options</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>cp</code></td>
                                <td>Copy files/directories</td>
                                <td><code>-r</code> (recursive), <code>-p</code> (preserve), <code>-i</code> (interactive)</td>
                            </tr>
                            <tr>
                                <td><code>mv</code></td>
                                <td>Move or rename files</td>
                                <td><code>-i</code> (interactive), <code>-n</code> (no overwrite)</td>
                            </tr>
                            <tr>
                                <td><code>rm</code></td>
                                <td>Remove files/directories</td>
                                <td><code>-r</code> (recursive), <code>-f</code> (force), <code>-i</code> (interactive)</td>
                            </tr>
                            <tr>
                                <td><code>touch</code></td>
                                <td>Create file / update timestamp</td>
                                <td><code>-t</code> (set time), <code>-d</code> (date string)</td>
                            </tr>
                            <tr>
                                <td><code>mkdir</code></td>
                                <td>Create directories</td>
                                <td><code>-p</code> (create parents)</td>
                            </tr>
                            <tr>
                                <td><code>rmdir</code></td>
                                <td>Remove empty directories</td>
                                <td><code>-p</code> (remove parents)</td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="warning-box">
                        <strong>Danger Zone:</strong> <code>rm -rf</code> is extremely dangerous! It recursively deletes without confirmation. Never run <code>rm -rf /</code> or <code>rm -rf *</code> with elevated privileges. Always double-check paths before using <code>-rf</code>.
                    </div>

                    <!-- Section 2: File Permissions -->
                    <h2>File Permissions with chmod</h2>
                    <p>Unix file permissions control who can read, write, and execute files. The <code>chmod</code> command lets you modify these permissions.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/files-manipulation-permissions.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-permissions" />
                    </jsp:include>

                    <h3>Understanding Permission Numbers</h3>
                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Permission</th>
                                <th>Letter</th>
                                <th>Number</th>
                                <th>Meaning</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Read</td>
                                <td>r</td>
                                <td>4</td>
                                <td>View file contents / list directory</td>
                            </tr>
                            <tr>
                                <td>Write</td>
                                <td>w</td>
                                <td>2</td>
                                <td>Modify file / add/remove files in directory</td>
                            </tr>
                            <tr>
                                <td>Execute</td>
                                <td>x</td>
                                <td>1</td>
                                <td>Run as program / enter directory</td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="info-box">
                        <strong>Common Permission Patterns:</strong>
                        <ul>
                            <li><code>755</code> - Executables (owner: full, others: read+execute)</li>
                            <li><code>644</code> - Regular files (owner: read+write, others: read)</li>
                            <li><code>700</code> - Private files (owner only)</li>
                            <li><code>600</code> - Sensitive files like SSH keys</li>
                        </ul>
                    </div>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Use symbolic mode for clarity: <code>chmod u+x script.sh</code> (add execute for user), <code>chmod go-w file</code> (remove write for group/others), <code>chmod a+r file</code> (add read for all).
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Finding Files -->
                    <h2>Finding Files with find</h2>
                    <p>The <code>find</code> command is incredibly powerful for locating files based on name, type, size, time, permissions, and more.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/files-manipulation-find.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-find" />
                    </jsp:include>

                    <h3>Essential find Options</h3>
                    <pre><code class="language-bash"># Find by name
find /path -name "*.txt"           # Case-sensitive
find /path -iname "*.TXT"          # Case-insensitive

# Find by type
find /path -type f                 # Files only
find /path -type d                 # Directories only
find /path -type l                 # Symbolic links

# Find by time
find /path -mtime -7               # Modified within 7 days
find /path -mtime +30              # Modified more than 30 days ago
find /path -mmin -60               # Modified within 60 minutes

# Find by size
find /path -size +100M             # Larger than 100MB
find /path -size -1k               # Smaller than 1KB

# Find by permissions
find /path -perm 755               # Exact permissions
find /path -perm -u+x              # At least user executable

# Execute command on results
find /path -name "*.log" -delete   # Delete matching files
find /path -name "*.sh" -exec chmod +x {} \;  # Make executable
find /path -type f -exec grep -l "pattern" {} \;  # Search in files</code></pre>

                    <div class="info-box">
                        <strong>find + xargs:</strong> For better performance with many files, use <code>xargs</code>:
                        <pre><code class="language-bash">find /path -name "*.txt" | xargs grep "pattern"
find /path -name "*.log" -print0 | xargs -0 rm -f  # Handle spaces in names</code></pre>
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Forgetting -r for directories</h4>
                        <pre><code class="language-bash"># Wrong - can't copy directory without -r
cp mydir newdir        # Error!

# Correct
cp -r mydir newdir</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Dangerous rm patterns</h4>
                        <pre><code class="language-bash"># EXTREMELY DANGEROUS!
rm -rf /                  # Deletes everything
rm -rf \$VAR/*            # If VAR is empty, becomes rm -rf /*

# Safer patterns
rm -rf "\${VAR:?Error: VAR not set}/"*  # Fails if VAR is empty
[[ -n "\$VAR" ]] && rm -rf "\$VAR"/*</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Wrong chmod numbers</h4>
                        <pre><code class="language-bash"># Wrong - gives everyone write access
chmod 777 sensitive_file.txt  # DANGEROUS!

# Correct - restrictive permissions
chmod 600 sensitive_file.txt  # Owner only
chmod 644 public_file.txt     # Owner write, others read</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Forgetting quotes with find</h4>
                        <pre><code class="language-bash"># Wrong - shell expands * before find sees it
find /path -name *.txt

# Correct - quotes prevent shell expansion
find /path -name "*.txt"</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: File Organizer Script</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a script that organizes files by extension!</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Create directories for different file types (txt, log, sh)</li>
                            <li>Move files to appropriate directories based on extension</li>
                            <li>Set correct permissions (755 for scripts, 644 for others)</li>
                            <li>Count files moved to each directory</li>
                        </ul>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-bash">#!/bin/bash
# File Organizer Script

source_dir="/tmp/organize_test"
mkdir -p "\$source_dir"

# Create test files
touch "\$source_dir"/{file1.txt,file2.txt,app.log,error.log,script.sh,deploy.sh}

echo "=== File Organizer ==="
echo "Source: \$source_dir"
echo ""

# Create category directories
mkdir -p "\$source_dir"/{text_files,log_files,scripts}

# Move and count files
txt_count=0
log_count=0
sh_count=0

# Move .txt files
for f in "\$source_dir"/*.txt 2>/dev/null; do
    [[ -f "\$f" ]] || continue
    mv "\$f" "\$source_dir/text_files/"
    chmod 644 "\$source_dir/text_files/\$(basename "\$f")"
    ((txt_count++))
done

# Move .log files
for f in "\$source_dir"/*.log 2>/dev/null; do
    [[ -f "\$f" ]] || continue
    mv "\$f" "\$source_dir/log_files/"
    chmod 644 "\$source_dir/log_files/\$(basename "\$f")"
    ((log_count++))
done

# Move .sh files
for f in "\$source_dir"/*.sh 2>/dev/null; do
    [[ -f "\$f" ]] || continue
    mv "\$f" "\$source_dir/scripts/"
    chmod 755 "\$source_dir/scripts/\$(basename "\$f")"
    ((sh_count++))
done

echo "Files organized:"
echo "  Text files: \$txt_count"
echo "  Log files: \$log_count"
echo "  Scripts: \$sh_count"
echo ""
echo "Directory structure:"
find "\$source_dir" -type f

# Cleanup
rm -rf "\$source_dir"</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>cp:</strong> Copy files (<code>-r</code> for directories, <code>-p</code> preserve attributes)</li>
                            <li><strong>mv:</strong> Move or rename files and directories</li>
                            <li><strong>rm:</strong> Delete files (<code>-r</code> for directories, use <code>-i</code> for safety)</li>
                            <li><strong>chmod:</strong> Change permissions (numeric: 755, 644 or symbolic: u+x, go-w)</li>
                            <li><strong>find:</strong> Search files by name, type, time, size, permissions</li>
                            <li><strong>Safety:</strong> Always quote variables, double-check <code>rm -rf</code> commands</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now let's explore <strong>File Testing</strong> in more depth. You'll learn advanced techniques for checking file properties, comparing files, and making your scripts robust with proper file validation!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="files-writing.jsp" />
                    <jsp:param name="prevTitle" value="File Writing" />
                    <jsp:param name="nextLink" value="files-testing.jsp" />
                    <jsp:param name="nextTitle" value="File Testing" />
                    <jsp:param name="currentLessonId" value="files-manipulation" />
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
