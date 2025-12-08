<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "practices-logging");
   request.setAttribute("currentModule", "Professional Practices"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Logging - Bash Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn to implement professional logging in Bash scripts with log levels, timestamps, file rotation, and structured output for debugging and monitoring.">
    <meta name="keywords"
        content="bash logging, shell script logging, bash log levels, bash timestamps, bash debug logging, script monitoring">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Logging - Bash Tutorial">
    <meta property="og:description" content="Implement professional logging with levels, timestamps, and file output.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/practices-logging.jsp">
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
        "name": "Bash Logging",
        "description": "Learn to implement professional logging in Bash with log levels, timestamps, and file output.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Advanced",
        "teaches": ["Log levels", "Timestamps", "File logging", "Log rotation", "Structured logging", "Debug output"],
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

<body class="tutorial-body no-preview" data-lesson="practices-logging">
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
                    <span>Logging</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Logging</h1>
                    <div class="lesson-meta">
                        <span>Advanced</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Good logging transforms debugging from guesswork into detective work. Scripts that silently do their job are great—until something goes wrong. This lesson teaches you to implement professional logging that helps you understand exactly what your script did, when, and why it failed!</p>

                    <!-- Section 1: Basic Logging -->
                    <h2>Basic Logging Functions</h2>
                    <p>Start with simple logging functions that add timestamps and identify message types.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/practices-logging.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-basic" />
                    </jsp:include>

                    <h3>Essential Logging Functions</h3>
                    <pre><code class="language-bash"># Timestamp function
timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

# Basic log function
log() {
    echo "[\$(timestamp)] \$*"
}

# Error logging (to stderr)
log_error() {
    echo "[\$(timestamp)] ERROR: \$*" >&2
}

# Warning logging
log_warn() {
    echo "[\$(timestamp)] WARN: \$*" >&2
}

# Info logging
log_info() {
    echo "[\$(timestamp)] INFO: \$*"
}

# Debug logging (controlled by variable)
log_debug() {
    [[ "\${DEBUG:-false}" == "true" ]] && echo "[\$(timestamp)] DEBUG: \$*"
}</code></pre>

                    <div class="info-box">
                        <strong>stderr vs stdout:</strong> Write errors and warnings to stderr (<code>&gt;&2</code>) so they appear even when stdout is redirected. This keeps error messages visible: <code>./script.sh > output.log</code> still shows errors.
                    </div>

                    <!-- Section 2: Log Levels -->
                    <h2>Implementing Log Levels</h2>
                    <p>Log levels let you control verbosity without changing code.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/practices-logging-levels.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-levels" />
                    </jsp:include>

                    <h3>Standard Log Levels</h3>
                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Level</th>
                                <th>Value</th>
                                <th>When to Use</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>DEBUG</td>
                                <td>0</td>
                                <td>Detailed diagnostic information</td>
                            </tr>
                            <tr>
                                <td>INFO</td>
                                <td>1</td>
                                <td>General progress information</td>
                            </tr>
                            <tr>
                                <td>WARN</td>
                                <td>2</td>
                                <td>Warning conditions, recoverable issues</td>
                            </tr>
                            <tr>
                                <td>ERROR</td>
                                <td>3</td>
                                <td>Error conditions, but script continues</td>
                            </tr>
                            <tr>
                                <td>FATAL</td>
                                <td>4</td>
                                <td>Critical errors, script will exit</td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="tip-box">
                        <strong>Default Level:</strong> Set INFO as default. Use DEBUG only when troubleshooting. In production, WARN or ERROR reduces noise.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: File Logging -->
                    <h2>Logging to Files</h2>
                    <p>For long-running scripts and services, log to files for later analysis.</p>

                    <pre><code class="language-bash"># Setup log file
LOG_FILE="\${LOG_FILE:-/var/log/myapp/app.log}"
LOG_DIR="\$(dirname "\$LOG_FILE")"

# Ensure log directory exists
setup_logging() {
    mkdir -p "\$LOG_DIR" || {
        echo "Cannot create log directory: \$LOG_DIR" >&2
        exit 1
    }

    # Test write access
    touch "\$LOG_FILE" || {
        echo "Cannot write to log file: \$LOG_FILE" >&2
        exit 1
    }
}

# Log to both file and stdout
log() {
    local message="[\$(date '+%Y-%m-%d %H:%M:%S')] [\$\$] \$*"
    echo "\$message" | tee -a "\$LOG_FILE"
}

# Log only to file (silent mode)
log_quiet() {
    echo "[\$(date '+%Y-%m-%d %H:%M:%S')] [\$\$] \$*" >> "\$LOG_FILE"
}

# Redirect all output to log file
exec_with_logging() {
    exec > >(tee -a "\$LOG_FILE") 2>&1
}

# Log with rotation (simple)
rotate_log() {
    local max_size=\${1:-10485760}  # 10MB default

    if [[ -f "\$LOG_FILE" ]]; then
        local size=\$(stat -f%z "\$LOG_FILE" 2>/dev/null || stat -c%s "\$LOG_FILE")
        if [[ \$size -gt \$max_size ]]; then
            mv "\$LOG_FILE" "\$LOG_FILE.\$(date +%Y%m%d%H%M%S)"
            touch "\$LOG_FILE"
            log "Log rotated"
        fi
    fi
}</code></pre>

                    <div class="warning-box">
                        <strong>Log File Permissions:</strong> Be careful with log file permissions. Sensitive data in logs should not be world-readable. Use <code>chmod 640</code> for log files.
                    </div>

                    <!-- Section 4: Structured Logging -->
                    <h2>Structured Logging</h2>
                    <p>For scripts that integrate with log aggregators, use structured formats like JSON.</p>

                    <pre><code class="language-bash"># JSON logging
log_json() {
    local level="\$1"
    local message="\$2"
    shift 2

    # Build extra fields
    local extra=""
    while [[ \$# -gt 0 ]]; do
        extra="\$extra, \"\$1\": \"\$2\""
        shift 2
    done

    printf '{"timestamp":"%s","level":"%s","pid":%d,"message":"%s"%s}\\n' \\
        "\$(date -u +%Y-%m-%dT%H:%M:%SZ)" \\
        "\$level" \\
        "\$\$" \\
        "\$message" \\
        "\$extra"
}

# Usage
log_json "INFO" "User logged in" "user" "john" "ip" "192.168.1.1"
# Output: {"timestamp":"2024-01-15T10:30:00Z","level":"INFO","pid":1234,"message":"User logged in", "user": "john", "ip": "192.168.1.1"}

# Key-value logging (syslog style)
log_kv() {
    local level="\$1"
    local message="\$2"
    shift 2

    local kv=""
    while [[ \$# -gt 0 ]]; do
        kv="\$kv \$1=\"\$2\""
        shift 2
    done

    echo "[\$(date '+%Y-%m-%d %H:%M:%S')] \$level: \$message\$kv"
}

# Usage
log_kv "INFO" "Request completed" "method" "GET" "path" "/api" "status" "200"</code></pre>

                    <!-- Section 5: Debug Techniques -->
                    <h2>Debug Logging Techniques</h2>
                    <p>Advanced techniques for troubleshooting complex scripts.</p>

                    <pre><code class="language-bash"># Function entry/exit logging
log_function() {
    local func="\${FUNCNAME[1]}"
    log_debug "Entering: \$func(\$*)"
}

log_function_exit() {
    local func="\${FUNCNAME[1]}"
    local code="\${1:-0}"
    log_debug "Exiting: \$func (code=\$code)"
}

# Wrap function with logging
process_data() {
    log_function "\$@"

    # Do work...
    local result="success"

    log_function_exit 0
    return 0
}

# Variable dump
dump_vars() {
    log_debug "=== Variable Dump ==="
    local var
    for var in "\$@"; do
        log_debug "  \$var=\${!var:-<unset>}"
    done
}

# Execution trace for specific section
trace_on() {
    set -x
}

trace_off() {
    set +x
}

# Conditional trace
[[ "\${TRACE:-false}" == "true" ]] && set -x

# Stack trace on error
print_stack() {
    local i
    echo "Stack trace:" >&2
    for ((i=1; i<\${#FUNCNAME[@]}; i++)); do
        echo "  \$i: \${FUNCNAME[i]}() at \${BASH_SOURCE[i]}:\${BASH_LINENO[i-1]}" >&2
    done
}
trap 'print_stack' ERR</code></pre>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Logging sensitive data</h4>
                        <pre><code class="language-bash"># Wrong - password in logs!
log "Connecting with password: \$DB_PASSWORD"

# Correct - mask sensitive data
log "Connecting with password: ****"
log "Connecting as user: \$DB_USER"</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. No timestamps</h4>
                        <pre><code class="language-bash"># Wrong - no context
echo "Starting backup"

# Correct - when did it happen?
log "Starting backup"  # Includes timestamp</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Debug code left in production</h4>
                        <pre><code class="language-bash"># Wrong - always prints debug
echo "DEBUG: var=\$var"

# Correct - controlled by flag
log_debug "var=\$var"  # Only shows when DEBUG=true</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Complete Logging System</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Build a reusable logging library!</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Support DEBUG, INFO, WARN, ERROR levels</li>
                            <li>Include timestamps and PID</li>
                            <li>Output to both console and file</li>
                            <li>Configurable via environment variables</li>
                        </ul>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-bash">#!/usr/bin/env bash
# logging.sh - Reusable logging library

# Configuration (via environment)
LOG_LEVEL="\${LOG_LEVEL:-INFO}"
LOG_FILE="\${LOG_FILE:-}"
LOG_FORMAT="\${LOG_FORMAT:-text}"  # text or json

# Level values
declare -A LOG_LEVELS=(
    [DEBUG]=0 [INFO]=1 [WARN]=2 [ERROR]=3
)

# Initialize
_log_init() {
    if [[ -n "\$LOG_FILE" ]]; then
        mkdir -p "\$(dirname "\$LOG_FILE")" 2>/dev/null
    fi
}

# Core log function
_log() {
    local level="\$1"
    local message="\$2"

    # Check level threshold
    local level_val=\${LOG_LEVELS[\$level]:-1}
    local threshold=\${LOG_LEVELS[\$LOG_LEVEL]:-1}
    [[ \$level_val -lt \$threshold ]] && return 0

    local timestamp=\$(date '+%Y-%m-%d %H:%M:%S')
    local output

    if [[ "\$LOG_FORMAT" == "json" ]]; then
        output=\$(printf '{"ts":"%s","level":"%s","pid":%d,"msg":"%s"}' \\
            "\$timestamp" "\$level" "\$\$" "\$message")
    else
        output="[\$timestamp] [\$\$] \$level: \$message"
    fi

    # Output to console
    if [[ "\$level" == "ERROR" || "\$level" == "WARN" ]]; then
        echo "\$output" >&2
    else
        echo "\$output"
    fi

    # Output to file
    [[ -n "\$LOG_FILE" ]] && echo "\$output" >> "\$LOG_FILE"
}

# Public functions
log_debug() { _log "DEBUG" "\$*"; }
log_info()  { _log "INFO" "\$*"; }
log_warn()  { _log "WARN" "\$*"; }
log_error() { _log "ERROR" "\$*"; }

# Initialize on source
_log_init

# Example usage when run directly
if [[ "\${BASH_SOURCE[0]}" == "\${0}" ]]; then
    log_debug "Debug message"
    log_info "Info message"
    log_warn "Warning message"
    log_error "Error message"
fi</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Timestamps:</strong> Always include timestamps in log messages</li>
                            <li><strong>Log Levels:</strong> Use DEBUG, INFO, WARN, ERROR with configurable threshold</li>
                            <li><strong>stderr:</strong> Write errors/warnings to stderr for visibility</li>
                            <li><strong>File Logging:</strong> Log to files for long-running processes</li>
                            <li><strong>Structured:</strong> Use JSON format for log aggregation systems</li>
                            <li><strong>Security:</strong> Never log passwords, tokens, or sensitive data</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Scripts often need external <strong>Configuration Files</strong>. Next, you'll learn to load, parse, and validate configuration from files and environment variables!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="practices-error-handling.jsp" />
                    <jsp:param name="prevTitle" value="Error Handling" />
                    <jsp:param name="nextLink" value="practices-configuration.jsp" />
                    <jsp:param name="nextTitle" value="Configuration Files" />
                    <jsp:param name="currentLessonId" value="practices-logging" />
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
