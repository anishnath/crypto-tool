<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "practices-best-practices");
   request.setAttribute("currentModule", "Professional Practices"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Best Practices - Bash Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn Bash scripting best practices including code style, naming conventions, error handling patterns, and code organization for professional shell scripts.">
    <meta name="keywords"
        content="bash best practices, shell script style guide, bash coding standards, bash naming conventions, professional bash scripts">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Best Practices - Bash Tutorial">
    <meta property="og:description" content="Master professional Bash scripting standards and coding conventions.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/practices-best-practices.jsp">
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
        "name": "Bash Best Practices",
        "description": "Learn professional Bash scripting standards including code style, naming conventions, and organization.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Advanced",
        "teaches": ["Code style", "Naming conventions", "Script organization", "Documentation", "Defensive programming", "Portability"],
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

<body class="tutorial-body no-preview" data-lesson="practices-best-practices">
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
                    <span>Best Practices</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Best Practices</h1>
                    <div class="lesson-meta">
                        <span>Advanced</span>
                        <span>~30 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Writing Bash scripts that work is one thing—writing scripts that are maintainable, readable, and robust is another. This lesson covers professional coding standards that will make your scripts production-ready. Following these practices helps you and others understand, debug, and extend your code!</p>

                    <!-- Section 1: Code Style -->
                    <h2>Code Style Guidelines</h2>
                    <p>Consistent style makes code easier to read and maintain. Here are industry-standard conventions.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/practices-best-practices.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-style" />
                    </jsp:include>

                    <h3>Essential Style Rules</h3>
                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Rule</th>
                                <th>Good</th>
                                <th>Bad</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Indentation</td>
                                <td>2 or 4 spaces, consistent</td>
                                <td>Mixed tabs/spaces</td>
                            </tr>
                            <tr>
                                <td>Line length</td>
                                <td>Max 80-100 characters</td>
                                <td>Very long single lines</td>
                            </tr>
                            <tr>
                                <td>Quoting</td>
                                <td><code>"\$var"</code></td>
                                <td><code>\$var</code></td>
                            </tr>
                            <tr>
                                <td>Test syntax</td>
                                <td><code>[[ ]]</code></td>
                                <td><code>[ ]</code></td>
                            </tr>
                            <tr>
                                <td>Function style</td>
                                <td><code>func_name() { }</code></td>
                                <td><code>function func_name { }</code></td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="info-box">
                        <strong>Shebang Best Practice:</strong> Always use <code>#!/usr/bin/env bash</code> for portability, or <code>#!/bin/bash</code> if you need a specific path. Never omit the shebang!
                    </div>

                    <!-- Section 2: Naming Conventions -->
                    <h2>Naming Conventions</h2>
                    <p>Clear, consistent naming makes code self-documenting.</p>

                    <pre><code class="language-bash"># Variables: lowercase with underscores
user_name="john"
max_retries=3
config_file="/etc/app.conf"

# Constants: UPPERCASE with underscores
readonly MAX_CONNECTIONS=100
readonly DEFAULT_TIMEOUT=30
declare -r LOG_DIR="/var/log/myapp"

# Functions: lowercase with underscores, verb_noun pattern
get_user_input() { ... }
validate_config() { ... }
process_file() { ... }

# Private/internal functions: prefix with underscore
_helper_function() { ... }
_validate_internal() { ... }

# Boolean variables: use is_, has_, can_ prefixes
is_valid=true
has_error=false
can_write=true

# Arrays: plural names
declare -a users=()
declare -a log_files=()
declare -A config_options=()</code></pre>

                    <div class="tip-box">
                        <strong>Descriptive Names:</strong> Prefer <code>user_count</code> over <code>cnt</code>, <code>config_file</code> over <code>cf</code>. The few extra characters are worth the clarity.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Script Organization -->
                    <h2>Script Organization</h2>
                    <p>Well-organized scripts follow a predictable structure.</p>

                    <pre><code class="language-bash">#!/usr/bin/env bash
#
# Script: deploy.sh
# Description: Deploy application to production servers
# Author: Your Name
# Date: 2024-01-15
# Version: 1.0.0
#

# ==============================================================================
# CONFIGURATION
# ==============================================================================
set -euo pipefail
IFS=\$'\\n\\t'

readonly SCRIPT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_NAME="\$(basename "\${BASH_SOURCE[0]}")"

# Default values
readonly DEFAULT_ENV="staging"
readonly DEFAULT_TIMEOUT=60

# ==============================================================================
# GLOBALS
# ==============================================================================
declare -g verbose=false
declare -g dry_run=false
declare -g environment="\$DEFAULT_ENV"

# ==============================================================================
# FUNCTIONS
# ==============================================================================

usage() {
    cat << EOF
Usage: \$SCRIPT_NAME [OPTIONS] <target>

Deploy application to specified environment.

Options:
    -e, --env ENV       Target environment (default: \$DEFAULT_ENV)
    -v, --verbose       Enable verbose output
    -n, --dry-run       Show what would be done
    -h, --help          Show this help message

Examples:
    \$SCRIPT_NAME -e production server1
    \$SCRIPT_NAME --dry-run -v server2
EOF
}

log() {
    echo "[\$(date '+%Y-%m-%d %H:%M:%S')] \$*"
}

die() {
    echo "ERROR: \$*" >&2
    exit 1
}

# ==============================================================================
# MAIN
# ==============================================================================

main() {
    # Parse arguments
    # Validate inputs
    # Execute logic
    log "Deployment complete"
}

# Only run main if script is executed (not sourced)
if [[ "\${BASH_SOURCE[0]}" == "\${0}" ]]; then
    main "\$@"
fi</code></pre>

                    <h3>Section Order</h3>
                    <ol>
                        <li><strong>Shebang and header comments</strong></li>
                        <li><strong>Configuration:</strong> set options, constants, defaults</li>
                        <li><strong>Global variables:</strong> declared explicitly</li>
                        <li><strong>Functions:</strong> utility functions first, then main logic</li>
                        <li><strong>Main:</strong> entry point, argument parsing</li>
                        <li><strong>Execution guard:</strong> check if sourced vs executed</li>
                    </ol>

                    <!-- Section 4: Defensive Programming -->
                    <h2>Defensive Programming</h2>
                    <p>Write scripts that fail safely and handle edge cases.</p>

                    <pre><code class="language-bash"># Always start with strict mode
set -euo pipefail

# Validate all inputs
validate_input() {
    local input="\$1"

    [[ -z "\$input" ]] && die "Input required"
    [[ "\$input" =~ ^[a-zA-Z0-9_-]+\$ ]] || die "Invalid characters in input"

    return 0
}

# Check dependencies at startup
check_dependencies() {
    local deps=(curl jq awk)

    for cmd in "\${deps[@]}"; do
        command -v "\$cmd" >/dev/null 2>&1 || {
            die "Required command not found: \$cmd"
        }
    done
}

# Use default values
config_file="\${CONFIG_FILE:-/etc/default.conf}"
timeout="\${TIMEOUT:-30}"

# Check file existence before operations
[[ -f "\$config_file" ]] || die "Config not found: \$config_file"
[[ -r "\$config_file" ]] || die "Config not readable: \$config_file"

# Use temporary files safely
temp_file=\$(mktemp) || die "Failed to create temp file"
trap 'rm -f "\$temp_file"' EXIT

# Quote all variable expansions
process_file "\$input_file"  # Good
process_file \$input_file    # Bad - word splitting!</code></pre>

                    <div class="warning-box">
                        <strong>The set -euo pipefail Trio:</strong>
                        <ul>
                            <li><code>-e</code>: Exit on any command failure</li>
                            <li><code>-u</code>: Exit on undefined variable</li>
                            <li><code>-o pipefail</code>: Pipeline fails if any command fails</li>
                        </ul>
                        These catch most common scripting errors automatically.
                    </div>

                    <!-- Section 5: Documentation -->
                    <h2>Documentation Standards</h2>
                    <p>Good documentation helps future maintainers (including yourself).</p>

                    <pre><code class="language-bash"># File header - describe purpose, author, usage
#!/usr/bin/env bash
#
# backup.sh - Automated backup script for MySQL databases
#
# Usage: backup.sh [-d database] [-o output_dir] [-r retention_days]
#
# Environment Variables:
#   MYSQL_HOST     - Database host (default: localhost)
#   MYSQL_USER     - Database user (required)
#   MYSQL_PASSWORD - Database password (required)
#
# Exit Codes:
#   0 - Success
#   1 - General error
#   2 - Missing dependency
#   3 - Configuration error
#

# Function documentation
# @description Validates database connection
# @param \$1 hostname
# @param \$2 username
# @return 0 on success, 1 on failure
validate_connection() {
    local host="\$1"
    local user="\$2"

    # Implementation...
}

# Inline comments for complex logic
# Calculate retention date (files older than this will be deleted)
# Using -mtime +N finds files modified MORE than N days ago
retention_date=\$(date -d "-\${retention_days} days" +%Y%m%d)</code></pre>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Not quoting variables</h4>
                        <pre><code class="language-bash"># Wrong - word splitting and glob expansion
rm -rf \$dir/*
[ -f \$file ]

# Correct - always quote
rm -rf "\$dir"/*
[[ -f "\$file" ]]</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Using deprecated syntax</h4>
                        <pre><code class="language-bash"># Wrong - old style
result=\`command\`
[ \$a -eq \$b ]
function myFunc {

# Correct - modern style
result=\$(command)
[[ \$a -eq \$b ]]
myFunc() {</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Hardcoding paths</h4>
                        <pre><code class="language-bash"># Wrong - fragile
cd /home/user/project
source /home/user/config.sh

# Correct - relative to script
SCRIPT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
cd "\$SCRIPT_DIR"
source "\$SCRIPT_DIR/config.sh"</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Ignoring exit codes</h4>
                        <pre><code class="language-bash"># Wrong - continues even if command fails
cp important.txt backup/
rm important.txt

# Correct - check or use set -e
cp important.txt backup/ || die "Copy failed"
rm important.txt

# Or with set -e at script start
set -e
cp important.txt backup/
rm important.txt</code></pre>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Consistency:</strong> Use consistent indentation (2-4 spaces), naming, and style</li>
                            <li><strong>Naming:</strong> snake_case for variables/functions, UPPERCASE for constants</li>
                            <li><strong>Organization:</strong> Follow standard section order: header → config → functions → main</li>
                            <li><strong>Defensive:</strong> Always use <code>set -euo pipefail</code> and quote variables</li>
                            <li><strong>Documentation:</strong> Include header comments, function docs, and inline explanations</li>
                            <li><strong>Modern syntax:</strong> Use <code>[[ ]]</code>, <code>\$()</code>, and <code>func() {}</code> style</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now let's dive deeper into <strong>Error Handling</strong>. You'll learn advanced techniques with <code>set</code> options, <code>trap</code> commands, and building robust error recovery patterns!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="advanced-parameter-expansion.jsp" />
                    <jsp:param name="prevTitle" value="Parameter Expansion Advanced" />
                    <jsp:param name="nextLink" value="practices-error-handling.jsp" />
                    <jsp:param name="nextTitle" value="Error Handling" />
                    <jsp:param name="currentLessonId" value="practices-best-practices" />
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
