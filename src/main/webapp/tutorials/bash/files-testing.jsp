<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "files-testing");
   request.setAttribute("currentModule", "File Operations"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>File Testing - Bash Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn advanced Bash file testing techniques for validation, existence checks, permission testing, and building robust scripts with proper file handling.">
    <meta name="keywords"
        content="bash file test, bash file exists, bash check file, bash file validation, bash -f -d -e, shell script file check">

    <meta property="og:type" content="article">
    <meta property="og:title" content="File Testing - Bash Tutorial">
    <meta property="og:description" content="Master advanced file testing techniques for building robust Bash scripts.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/files-testing.jsp">
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
        "name": "Bash File Testing",
        "description": "Learn advanced Bash file testing techniques for validation and building robust scripts.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["File existence tests", "Permission testing", "File type detection", "Validation functions", "Safe file handling", "Error reporting"],
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

<body class="tutorial-body no-preview" data-lesson="files-testing">
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
                    <span>File Testing</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">File Testing</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~20 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Robust scripts always validate files before operating on them. This lesson dives deeper into file testing patterns, teaching you to build validation functions that handle edge cases gracefully. You'll learn to write defensive code that prevents errors and provides meaningful feedback!</p>

                    <!-- Section 1: Comprehensive File Tests -->
                    <h2>Comprehensive File Testing</h2>
                    <p>While we covered basic file tests in the Operators module, let's explore them in the context of real validation scenarios.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/files-testing.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-testing" />
                    </jsp:include>

                    <h3>Complete File Test Reference</h3>
                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Test</th>
                                <th>True When</th>
                                <th>Use Case</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>-e file</code></td>
                                <td>File exists (any type)</td>
                                <td>General existence check</td>
                            </tr>
                            <tr>
                                <td><code>-f file</code></td>
                                <td>Regular file exists</td>
                                <td>Before reading/writing files</td>
                            </tr>
                            <tr>
                                <td><code>-d dir</code></td>
                                <td>Directory exists</td>
                                <td>Before cd or listing</td>
                            </tr>
                            <tr>
                                <td><code>-L file</code></td>
                                <td>Symbolic link</td>
                                <td>Detecting symlinks</td>
                            </tr>
                            <tr>
                                <td><code>-r file</code></td>
                                <td>File is readable</td>
                                <td>Before cat, grep, etc.</td>
                            </tr>
                            <tr>
                                <td><code>-w file</code></td>
                                <td>File is writable</td>
                                <td>Before echo >, modification</td>
                            </tr>
                            <tr>
                                <td><code>-x file</code></td>
                                <td>File is executable</td>
                                <td>Before running scripts</td>
                            </tr>
                            <tr>
                                <td><code>-s file</code></td>
                                <td>File size > 0</td>
                                <td>Detect empty files</td>
                            </tr>
                            <tr>
                                <td><code>-O file</code></td>
                                <td>You own the file</td>
                                <td>Permission checks</td>
                            </tr>
                            <tr>
                                <td><code>-G file</code></td>
                                <td>Your group owns file</td>
                                <td>Group permission checks</td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="info-box">
                        <strong>Best Practice:</strong> Chain tests with <code>&&</code> for safety: <code>[[ -f "\$file" && -r "\$file" ]] && cat "\$file"</code>. This ensures you only read if the file exists AND is readable.
                    </div>

                    <!-- Section 2: Building Validation Functions -->
                    <h2>Building Validation Functions</h2>
                    <p>Encapsulate file validation logic into reusable functions for cleaner, more maintainable code.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/files-testing-validation.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-validation" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Use return codes in validation functions: return 0 for success, non-zero for failure. This lets callers use <code>if validate_file "\$f"; then ...</code> naturally.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Safe File Patterns -->
                    <h2>Safe File Operation Patterns</h2>
                    <p>Combine tests into patterns that prevent errors and handle edge cases gracefully.</p>

                    <pre><code class="language-bash"># Pattern 1: Safe read with fallback
safe_cat() {
    local file="\$1"
    local default="\$2"
    if [[ -f "\$file" && -r "\$file" ]]; then
        cat "\$file"
    else
        echo "\$default"
    fi
}
config=\$(safe_cat "/etc/app.conf" "default_config")

# Pattern 2: Require file or exit
require_file() {
    local file="\$1"
    if [[ ! -f "\$file" ]]; then
        echo "ERROR: Required file not found: \$file" >&2
        exit 1
    fi
}
require_file "/etc/critical.conf"

# Pattern 3: Wait for file with timeout
wait_for_file() {
    local file="\$1"
    local timeout="\${2:-30}"
    local count=0
    while [[ ! -f "\$file" && \$count -lt \$timeout ]]; do
        sleep 1
        ((count++))
    done
    [[ -f "\$file" ]]
}
wait_for_file "/tmp/ready.flag" 60 || exit 1

# Pattern 4: Process only if newer
process_if_newer() {
    local source="\$1"
    local target="\$2"
    if [[ "\$source" -nt "\$target" ]] || [[ ! -f "\$target" ]]; then
        process "\$source" > "\$target"
    fi
}</code></pre>

                    <div class="warning-box">
                        <strong>Race Conditions:</strong> Be aware that file state can change between testing and using. For critical operations, use atomic operations like <code>flock</code> or write-to-temp-then-move patterns.
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Testing without quoting</h4>
                        <pre><code class="language-bash"># Wrong - fails with spaces or special chars
[[ -f \$filename ]]

# Correct - always quote
[[ -f "\$filename" ]]</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Assuming test order doesn't matter</h4>
                        <pre><code class="language-bash"># Wrong - -r test may error if file doesn't exist
[[ -r "\$file" && -f "\$file" ]]

# Correct - test existence first
[[ -f "\$file" && -r "\$file" ]]</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Not handling empty variables</h4>
                        <pre><code class="language-bash"># Dangerous - if file is unset, tests current dir
[[ -d \$file ]]

# Safer - use parameter expansion
[[ -d "\${file:?File not specified}" ]]

# Or explicit check
[[ -n "\$file" && -d "\$file" ]]</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Config File Validator</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a function that validates configuration files!</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Check file exists and is readable</li>
                            <li>Verify file is not empty</li>
                            <li>Check for required keys (e.g., "host", "port")</li>
                            <li>Return appropriate exit codes and messages</li>
                        </ul>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-bash">#!/bin/bash
# Config File Validator

validate_config() {
    local config_file="\$1"
    local required_keys=("host" "port" "user")
    local errors=0

    echo "Validating: \$config_file"

    # Check existence
    if [[ ! -f "\$config_file" ]]; then
        echo "  ERROR: File not found"
        return 1
    fi

    # Check readable
    if [[ ! -r "\$config_file" ]]; then
        echo "  ERROR: File not readable"
        return 1
    fi

    # Check not empty
    if [[ ! -s "\$config_file" ]]; then
        echo "  ERROR: File is empty"
        return 1
    fi

    # Check required keys
    for key in "\${required_keys[@]}"; do
        if ! grep -q "^\$key=" "\$config_file"; then
            echo "  ERROR: Missing required key: \$key"
            ((errors++))
        fi
    done

    if [[ \$errors -eq 0 ]]; then
        echo "  SUCCESS: Config is valid"
        return 0
    else
        echo "  FAILED: \$errors error(s) found"
        return 1
    fi
}

# Test
config="/tmp/test.conf"
cat > "\$config" << 'EOF'
host=localhost
port=8080
user=admin
EOF

validate_config "\$config"
rm -f "\$config"</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Always Test:</strong> Check file existence and permissions before operations</li>
                            <li><strong>Test Order:</strong> Check existence (<code>-f</code>) before permissions (<code>-r</code>, <code>-w</code>)</li>
                            <li><strong>Quote Variables:</strong> Always quote paths in tests: <code>[[ -f "\$file" ]]</code></li>
                            <li><strong>Use Functions:</strong> Encapsulate validation logic for reusability</li>
                            <li><strong>Return Codes:</strong> Use 0 for success, non-zero for failure</li>
                            <li><strong>Error Messages:</strong> Write to stderr: <code>echo "error" >&2</code></li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now let's explore <strong>Working with Directories</strong>. You'll learn to traverse directories, process files recursively, and use the <code>find</code> command for powerful directory operations!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="files-manipulation.jsp" />
                    <jsp:param name="prevTitle" value="File Manipulation" />
                    <jsp:param name="nextLink" value="files-directories.jsp" />
                    <jsp:param name="nextTitle" value="Working with Directories" />
                    <jsp:param name="currentLessonId" value="files-testing" />
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
