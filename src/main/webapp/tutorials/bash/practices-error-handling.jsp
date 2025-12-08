<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "practices-error-handling");
   request.setAttribute("currentModule", "Professional Practices"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Error Handling - Bash Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Master Bash error handling with set -e, set -u, pipefail, trap commands, and robust error recovery patterns for production scripts.">
    <meta name="keywords"
        content="bash error handling, set -e, set -u, pipefail, bash trap, bash exit codes, shell script errors">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Error Handling - Bash Tutorial">
    <meta property="og:description" content="Learn professional error handling techniques for robust Bash scripts.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/practices-error-handling.jsp">
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
        "name": "Bash Error Handling",
        "description": "Master professional error handling techniques including set options, trap commands, and recovery patterns.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Advanced",
        "teaches": ["set -e", "set -u", "pipefail", "trap command", "Exit codes", "Error recovery", "Cleanup handlers"],
        "timeRequired": "PT30M",
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

<body class="tutorial-body no-preview" data-lesson="practices-error-handling">
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
                    <span>Error Handling</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Error Handling</h1>
                    <div class="lesson-meta">
                        <span>Advanced</span>
                        <span>~30 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Production scripts must handle errors gracefully. A script that silently continues after a failure can cause serious damage. This lesson teaches you to catch errors early, clean up properly, and provide meaningful feedback when things go wrong!</p>

                    <!-- Section 1: Set Options -->
                    <h2>The set Options</h2>
                    <p>Bash's <code>set</code> builtin enables critical error-handling behaviors.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/practices-error-handling.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-set" />
                    </jsp:include>

                    <h3>Essential Set Options</h3>
                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Option</th>
                                <th>Effect</th>
                                <th>Why Use It</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>set -e</code></td>
                                <td>Exit on error</td>
                                <td>Stops script when any command fails</td>
                            </tr>
                            <tr>
                                <td><code>set -u</code></td>
                                <td>Exit on undefined variable</td>
                                <td>Catches typos and missing variables</td>
                            </tr>
                            <tr>
                                <td><code>set -o pipefail</code></td>
                                <td>Pipeline returns rightmost error</td>
                                <td>Catches errors in pipelines</td>
                            </tr>
                            <tr>
                                <td><code>set -E</code></td>
                                <td>ERR trap inherited by functions</td>
                                <td>Error handlers work in functions</td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="info-box">
                        <strong>The Standard Header:</strong> Start every production script with:
                        <pre><code class="language-bash">#!/usr/bin/env bash
set -euo pipefail</code></pre>
                        This catches most common errors automatically.
                    </div>

                    <!-- Section 2: Exit Codes -->
                    <h2>Exit Codes</h2>
                    <p>Every command returns an exit code. Use them to detect and communicate errors.</p>

                    <pre><code class="language-bash"># Standard exit codes
# 0   - Success
# 1   - General error
# 2   - Misuse of command
# 126 - Permission denied
# 127 - Command not found
# 128+N - Fatal error signal N

# Check exit code with $?
command
if [[ \$? -ne 0 ]]; then
    echo "Command failed"
fi

# Better: use if directly
if ! command; then
    echo "Command failed"
fi

# Define custom exit codes
readonly EXIT_SUCCESS=0
readonly EXIT_ERROR=1
readonly EXIT_USAGE=2
readonly EXIT_CONFIG=3

die() {
    echo "ERROR: \$*" >&2
    exit "\${EXIT_ERROR}"
}

# Return specific codes
validate_config() {
    [[ -f "\$config" ]] || return \$EXIT_CONFIG
    return \$EXIT_SUCCESS
}

# Check specific failure
if ! validate_config; then
    case \$? in
        \$EXIT_CONFIG) echo "Configuration error" ;;
        *)            echo "Unknown error" ;;
    esac
fi</code></pre>

                    <div class="tip-box">
                        <strong>Documenting Exit Codes:</strong> Always document your script's exit codes in the header comments. This helps users understand and script around your tool.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Trap Command -->
                    <h2>The trap Command</h2>
                    <p>Use <code>trap</code> to execute cleanup code when your script exits or receives signals.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/practices-error-handling-trap.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-trap" />
                    </jsp:include>

                    <h3>Common Trap Patterns</h3>
                    <pre><code class="language-bash"># Cleanup on exit (any exit)
cleanup() {
    rm -f "\$temp_file"
    echo "Cleanup complete"
}
trap cleanup EXIT

# Handle specific signals
trap 'echo "Interrupted!"; exit 130' INT
trap 'echo "Terminated!"; exit 143' TERM

# Error handler
on_error() {
    local line="\$1"
    local code="\$2"
    echo "Error on line \$line: exit code \$code" >&2
}
trap 'on_error \${LINENO} \$?' ERR

# Multiple cleanup actions
declare -a cleanup_tasks=()

add_cleanup() {
    cleanup_tasks+=("\$1")
}

run_cleanup() {
    for task in "\${cleanup_tasks[@]}"; do
        eval "\$task" || true  # Continue even if cleanup fails
    done
}
trap run_cleanup EXIT

# Usage
temp_file=\$(mktemp)
add_cleanup "rm -f '\$temp_file'"

temp_dir=\$(mktemp -d)
add_cleanup "rm -rf '\$temp_dir'"</code></pre>

                    <h3>Common Signals</h3>
                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Signal</th>
                                <th>Number</th>
                                <th>Cause</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>EXIT</code></td>
                                <td>N/A</td>
                                <td>Any script exit (normal or error)</td>
                            </tr>
                            <tr>
                                <td><code>ERR</code></td>
                                <td>N/A</td>
                                <td>Command returns non-zero</td>
                            </tr>
                            <tr>
                                <td><code>INT</code></td>
                                <td>2</td>
                                <td>Ctrl+C (interrupt)</td>
                            </tr>
                            <tr>
                                <td><code>TERM</code></td>
                                <td>15</td>
                                <td>Termination request</td>
                            </tr>
                            <tr>
                                <td><code>HUP</code></td>
                                <td>1</td>
                                <td>Terminal closed</td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- Section 4: Error Recovery -->
                    <h2>Error Recovery Patterns</h2>
                    <p>Sometimes you want to handle errors gracefully rather than exit immediately.</p>

                    <pre><code class="language-bash"># Retry with backoff
retry() {
    local max_attempts=\${1:-3}
    local delay=\${2:-1}
    local cmd="\${@:3}"
    local attempt=1

    while [[ \$attempt -le \$max_attempts ]]; do
        if eval "\$cmd"; then
            return 0
        fi

        echo "Attempt \$attempt failed, retrying in \${delay}s..." >&2
        sleep "\$delay"
        ((attempt++))
        ((delay *= 2))  # Exponential backoff
    done

    echo "All \$max_attempts attempts failed" >&2
    return 1
}

# Usage
retry 3 2 curl -sf "https://api.example.com/health"

# Try/catch pattern
try() {
    local result
    result=\$("\$@" 2>&1) && echo "\$result" || {
        echo "Error: \$result" >&2
        return 1
    }
}

# Fallback chain
get_config() {
    cat "\$1" 2>/dev/null ||
    cat "\$HOME/.config/app.conf" 2>/dev/null ||
    cat "/etc/app/default.conf" 2>/dev/null ||
    echo "default_value"
}

# Conditional error handling
set +e  # Temporarily disable exit-on-error
risky_command
status=\$?
set -e  # Re-enable

if [[ \$status -ne 0 ]]; then
    handle_error \$status
fi</code></pre>

                    <div class="warning-box">
                        <strong>Disabling set -e:</strong> Use <code>set +e</code> sparingly and only for specific commands. Always re-enable with <code>set -e</code> immediately after.
                    </div>

                    <!-- Section 5: Assertions -->
                    <h2>Assertion Functions</h2>
                    <p>Build reusable assertion functions for common validation patterns.</p>

                    <pre><code class="language-bash"># Assertion library
assert_not_empty() {
    local name="\$1"
    local value="\$2"
    [[ -n "\$value" ]] || die "Assertion failed: \$name must not be empty"
}

assert_file_exists() {
    local file="\$1"
    [[ -f "\$file" ]] || die "Assertion failed: File not found: \$file"
}

assert_directory_exists() {
    local dir="\$1"
    [[ -d "\$dir" ]] || die "Assertion failed: Directory not found: \$dir"
}

assert_command_exists() {
    local cmd="\$1"
    command -v "\$cmd" &>/dev/null ||
        die "Assertion failed: Command not found: \$cmd"
}

assert_root() {
    [[ \$EUID -eq 0 ]] || die "This script must be run as root"
}

# Usage
main() {
    assert_command_exists "curl"
    assert_file_exists "\$config_file"
    assert_not_empty "API_KEY" "\$API_KEY"

    # Script continues only if all assertions pass
}</code></pre>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Not checking command success</h4>
                        <pre><code class="language-bash"># Wrong - continues even if cd fails!
cd /nonexistent
rm -rf *  # Deletes from wrong directory!

# Correct
cd /nonexistent || exit 1
rm -rf *

# Or with set -e
set -e
cd /nonexistent  # Script exits here</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Ignoring pipeline errors</h4>
                        <pre><code class="language-bash"># Wrong - only checks last command
cat missing.txt | grep pattern
echo "Status: \$?"  # Shows 0 or 1 from grep, not cat!

# Correct - use pipefail
set -o pipefail
cat missing.txt | grep pattern  # Now fails if cat fails</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Not cleaning up on error</h4>
                        <pre><code class="language-bash"># Wrong - temp file left behind on error
temp=\$(mktemp)
process_data > "\$temp"  # If this fails, temp remains
rm "\$temp"

# Correct - trap ensures cleanup
temp=\$(mktemp)
trap "rm -f '\$temp'" EXIT
process_data > "\$temp"
# temp is removed even on error</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Robust File Processor</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a script with comprehensive error handling!</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Use <code>set -euo pipefail</code></li>
                            <li>Validate input file exists</li>
                            <li>Use trap for cleanup</li>
                            <li>Provide meaningful error messages</li>
                            <li>Return appropriate exit codes</li>
                        </ul>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-bash">#!/usr/bin/env bash
set -euo pipefail

# Exit codes
readonly EXIT_SUCCESS=0
readonly EXIT_ERROR=1
readonly EXIT_USAGE=2

# Globals
temp_file=""

# Cleanup handler
cleanup() {
    [[ -n "\$temp_file" && -f "\$temp_file" ]] && rm -f "\$temp_file"
}
trap cleanup EXIT

# Error handler
on_error() {
    echo "ERROR: Script failed at line \$1" >&2
}
trap 'on_error \$LINENO' ERR

# Utility functions
die() {
    echo "ERROR: \$*" >&2
    exit \$EXIT_ERROR
}

usage() {
    echo "Usage: \$0 <input_file>"
    exit \$EXIT_USAGE
}

# Validation
validate_input() {
    local file="\$1"

    [[ -n "\$file" ]] || die "Input file required"
    [[ -f "\$file" ]] || die "File not found: \$file"
    [[ -r "\$file" ]] || die "File not readable: \$file"
}

# Main processing
process_file() {
    local input="\$1"
    temp_file=\$(mktemp) || die "Failed to create temp file"

    echo "Processing: \$input"

    # Simulate processing
    wc -l "\$input" > "\$temp_file"
    cat "\$temp_file"

    echo "Processing complete"
}

# Entry point
main() {
    [[ \$# -eq 1 ]] || usage

    validate_input "\$1"
    process_file "\$1"

    exit \$EXIT_SUCCESS
}

main "\$@"</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>set -euo pipefail:</strong> Essential trio for catching errors automatically</li>
                            <li><strong>Exit Codes:</strong> Use meaningful codes (0=success, non-zero=error types)</li>
                            <li><strong>trap EXIT:</strong> Always clean up temporary files and resources</li>
                            <li><strong>trap ERR:</strong> Add error context with line numbers</li>
                            <li><strong>Assertions:</strong> Validate preconditions early with clear messages</li>
                            <li><strong>Recovery:</strong> Implement retry logic for transient failures</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Good error handling needs good <strong>Logging</strong>. Next, you'll learn to implement logging functions with levels, timestamps, and proper output handling!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="practices-best-practices.jsp" />
                    <jsp:param name="prevTitle" value="Best Practices" />
                    <jsp:param name="nextLink" value="practices-logging.jsp" />
                    <jsp:param name="nextTitle" value="Logging" />
                    <jsp:param name="currentLessonId" value="practices-error-handling" />
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
