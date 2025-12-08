<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "practices-templates");
   request.setAttribute("currentModule", "Professional Practices"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Script Templates - Bash Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Professional Bash script templates and boilerplate code for common use cases. Start new scripts with best practices built in.">
    <meta name="keywords"
        content="bash script template, bash boilerplate, shell script starter, bash script structure, bash starter template">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Script Templates - Bash Tutorial">
    <meta property="og:description" content="Ready-to-use Bash script templates with best practices built in.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/practices-templates.jsp">
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
        "name": "Bash Script Templates",
        "description": "Professional script templates and boilerplate code for common Bash scripting use cases.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Advanced",
        "teaches": ["Script boilerplate", "Template patterns", "Minimal template", "Full CLI template", "Library template", "Service script"],
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

<body class="tutorial-body no-preview" data-lesson="practices-templates">
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
                    <span>Script Templates</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Script Templates</h1>
                    <div class="lesson-meta">
                        <span>Advanced</span>
                        <span>~20 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Starting from scratch is slow and error-prone. This lesson provides battle-tested templates you can copy and customize. Each template incorporates the best practices from this module—use them as starting points for your own scripts!</p>

                    <!-- Section 1: Minimal Template -->
                    <h2>Minimal Script Template</h2>
                    <p>For quick scripts that still need basic safety features.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/practices-templates.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-minimal" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>When to Use:</strong> Small utility scripts, automation tasks, quick prototypes. Add more structure as the script grows.
                    </div>

                    <!-- Section 2: CLI Template -->
                    <h2>Full CLI Application Template</h2>
                    <p>For user-facing command-line tools with argument parsing, help, and logging.</p>

                    <pre><code class="language-bash">#!/usr/bin/env bash
#
# script-name - Brief description of what this script does
#
# Usage: script-name [OPTIONS] <required-arg>
#
# Author: Your Name
# Date: 2024-01-15
# Version: 1.0.0
#

set -euo pipefail
IFS=\$'\\n\\t'

# ==============================================================================
# CONSTANTS
# ==============================================================================

readonly SCRIPT_NAME="\$(basename "\${BASH_SOURCE[0]}")"
readonly SCRIPT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
readonly VERSION="1.0.0"

# Exit codes
readonly EXIT_SUCCESS=0
readonly EXIT_ERROR=1
readonly EXIT_USAGE=2

# ==============================================================================
# DEFAULTS
# ==============================================================================

verbose=false
dry_run=false
config_file=""
log_level="INFO"

# ==============================================================================
# LOGGING
# ==============================================================================

log() { echo "[\$(date '+%Y-%m-%d %H:%M:%S')] \$*"; }
log_info() { log "INFO: \$*"; }
log_warn() { log "WARN: \$*" >&2; }
log_error() { log "ERROR: \$*" >&2; }
log_debug() { [[ "\$verbose" == "true" ]] && log "DEBUG: \$*"; }

die() {
    log_error "\$*"
    exit \$EXIT_ERROR
}

# ==============================================================================
# USAGE
# ==============================================================================

show_help() {
    cat << EOF
Usage: \$SCRIPT_NAME [OPTIONS] <target>

Brief description of what this script does.

Arguments:
    target              Description of required argument

Options:
    -c, --config FILE   Configuration file path
    -n, --dry-run       Show what would be done
    -v, --verbose       Enable verbose output
    -h, --help          Show this help message
    --version           Show version number

Examples:
    \$SCRIPT_NAME -v target
    \$SCRIPT_NAME --config=app.conf target

Environment:
    SCRIPT_CONFIG       Default config file path
    SCRIPT_LOG_LEVEL    Log level (DEBUG, INFO, WARN, ERROR)
EOF
}

show_version() {
    echo "\$SCRIPT_NAME version \$VERSION"
}

# ==============================================================================
# ARGUMENT PARSING
# ==============================================================================

parse_args() {
    while [[ \$# -gt 0 ]]; do
        case \$1 in
            -h|--help)
                show_help
                exit \$EXIT_SUCCESS
                ;;
            --version)
                show_version
                exit \$EXIT_SUCCESS
                ;;
            -v|--verbose)
                verbose=true
                shift
                ;;
            -n|--dry-run)
                dry_run=true
                shift
                ;;
            -c|--config)
                config_file="\$2"
                shift 2
                ;;
            --config=*)
                config_file="\${1#*=}"
                shift
                ;;
            --)
                shift
                break
                ;;
            -*)
                die "Unknown option: \$1"
                ;;
            *)
                break
                ;;
        esac
    done

    # Remaining args are positional
    target="\${1:-}"
}

# ==============================================================================
# VALIDATION
# ==============================================================================

validate_args() {
    [[ -z "\$target" ]] && {
        log_error "Missing required argument: target"
        echo "Try '\$SCRIPT_NAME --help' for usage." >&2
        exit \$EXIT_USAGE
    }

    [[ -n "\$config_file" && ! -f "\$config_file" ]] && {
        die "Config file not found: \$config_file"
    }
}

# ==============================================================================
# CLEANUP
# ==============================================================================

cleanup() {
    log_debug "Cleaning up..."
    # Add cleanup tasks here
}

trap cleanup EXIT

# ==============================================================================
# MAIN LOGIC
# ==============================================================================

do_work() {
    log_info "Processing target: \$target"

    if [[ "\$dry_run" == "true" ]]; then
        log_info "[DRY RUN] Would process \$target"
        return 0
    fi

    # Main logic here
    log_debug "Doing the work..."

    log_info "Done!"
}

# ==============================================================================
# ENTRY POINT
# ==============================================================================

main() {
    parse_args "\$@"
    validate_args
    do_work
}

# Only run main if executed (not sourced)
if [[ "\${BASH_SOURCE[0]}" == "\${0}" ]]; then
    main "\$@"
fi</code></pre>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Library Template -->
                    <h2>Library/Module Template</h2>
                    <p>For reusable functions that get sourced by other scripts.</p>

                    <pre><code class="language-bash">#!/usr/bin/env bash
#
# lib-name.sh - Reusable library for [purpose]
#
# Usage: source lib-name.sh
#
# Provides:
#   function1 - Description
#   function2 - Description
#

# Prevent double-sourcing
[[ -n "\${_LIB_NAME_LOADED:-}" ]] && return 0
readonly _LIB_NAME_LOADED=1

# ==============================================================================
# CONFIGURATION
# ==============================================================================

# Library defaults (can be overridden before sourcing)
: "\${LIB_DEBUG:=false}"
: "\${LIB_LOG_FILE:=}"

# ==============================================================================
# INTERNAL FUNCTIONS
# ==============================================================================

_lib_log() {
    [[ "\$LIB_DEBUG" == "true" ]] && echo "[lib-name] \$*" >&2
}

_lib_validate() {
    # Internal validation
    :
}

# ==============================================================================
# PUBLIC API
# ==============================================================================

# @description Does something useful
# @param \$1 input - The input value
# @return 0 on success, 1 on failure
# @example
#   result=\$(lib_function1 "input")
lib_function1() {
    local input="\${1:?Usage: lib_function1 <input>}"

    _lib_log "Processing: \$input"

    # Implementation
    echo "Processed: \$input"
    return 0
}

# @description Another useful function
# @param \$1 arg1 - First argument
# @param \$2 arg2 - Second argument (optional)
lib_function2() {
    local arg1="\$1"
    local arg2="\${2:-default}"

    _lib_log "Args: \$arg1, \$arg2"

    # Implementation
    return 0
}

# ==============================================================================
# INITIALIZATION
# ==============================================================================

_lib_validate

# Self-test when run directly
if [[ "\${BASH_SOURCE[0]}" == "\${0}" ]]; then
    echo "Running lib-name.sh self-test..."
    LIB_DEBUG=true

    echo "Testing lib_function1:"
    lib_function1 "test input"

    echo "Testing lib_function2:"
    lib_function2 "arg1" "arg2"

    echo "All tests passed!"
fi</code></pre>

                    <!-- Section 4: Service Template -->
                    <h2>Service/Daemon Template</h2>
                    <p>For long-running background scripts with signal handling.</p>

                    <pre><code class="language-bash">#!/usr/bin/env bash
#
# service-name - Long-running service script
#

set -euo pipefail

readonly SCRIPT_NAME="\$(basename "\$0")"
readonly PID_FILE="/var/run/\${SCRIPT_NAME}.pid"
readonly LOG_FILE="/var/log/\${SCRIPT_NAME}.log"

running=true

# ==============================================================================
# LOGGING
# ==============================================================================

log() {
    echo "[\$(date '+%Y-%m-%d %H:%M:%S')] [\$\$] \$*" | tee -a "\$LOG_FILE"
}

# ==============================================================================
# SIGNAL HANDLERS
# ==============================================================================

handle_shutdown() {
    log "Received shutdown signal"
    running=false
}

handle_reload() {
    log "Reloading configuration..."
    # Reload logic here
}

trap handle_shutdown SIGTERM SIGINT
trap handle_reload SIGHUP

# ==============================================================================
# PID FILE MANAGEMENT
# ==============================================================================

create_pid_file() {
    echo \$\$ > "\$PID_FILE"
    log "Created PID file: \$PID_FILE"
}

remove_pid_file() {
    rm -f "\$PID_FILE"
    log "Removed PID file"
}

check_already_running() {
    if [[ -f "\$PID_FILE" ]]; then
        local pid=\$(cat "\$PID_FILE")
        if kill -0 "\$pid" 2>/dev/null; then
            log "Already running with PID \$pid"
            exit 1
        fi
        log "Removing stale PID file"
        rm -f "\$PID_FILE"
    fi
}

# ==============================================================================
# MAIN LOOP
# ==============================================================================

do_work() {
    # Your service logic here
    log "Doing periodic work..."
    sleep 1
}

main() {
    check_already_running
    create_pid_file

    trap remove_pid_file EXIT

    log "Service started"

    while [[ "\$running" == "true" ]]; do
        do_work
    done

    log "Service stopped"
}

main "\$@"</code></pre>

                    <!-- Template Comparison -->
                    <h2>Template Comparison</h2>
                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Template</th>
                                <th>Best For</th>
                                <th>Features</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Minimal</td>
                                <td>Quick scripts, prototypes</td>
                                <td>Error handling, cleanup</td>
                            </tr>
                            <tr>
                                <td>CLI</td>
                                <td>User-facing tools</td>
                                <td>Args, help, logging, validation</td>
                            </tr>
                            <tr>
                                <td>Library</td>
                                <td>Reusable functions</td>
                                <td>Sourcing guard, documentation</td>
                            </tr>
                            <tr>
                                <td>Service</td>
                                <td>Background processes</td>
                                <td>Signals, PID file, main loop</td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Start with templates:</strong> Don't reinvent the wheel</li>
                            <li><strong>Minimal:</strong> Quick tasks with basic safety</li>
                            <li><strong>CLI:</strong> Full-featured command-line tools</li>
                            <li><strong>Library:</strong> Reusable code with source guard</li>
                            <li><strong>Service:</strong> Long-running with signal handling</li>
                            <li><strong>Customize:</strong> Add/remove features as needed</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now let's learn about <strong>Testing Scripts</strong>. You'll discover strategies for testing Bash scripts to ensure they work correctly!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="practices-arguments.jsp" />
                    <jsp:param name="prevTitle" value="Command Line Arguments" />
                    <jsp:param name="nextLink" value="practices-testing.jsp" />
                    <jsp:param name="nextTitle" value="Testing Scripts" />
                    <jsp:param name="currentLessonId" value="practices-templates" />
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
