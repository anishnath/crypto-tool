<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "practices-examples");
   request.setAttribute("currentModule", "Professional Practices"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Real-World Examples - Bash Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Complete, production-ready Bash script examples including backup systems, monitoring tools, deployment scripts, and automation tasks.">
    <meta name="keywords"
        content="bash backup script, bash monitoring script, bash deployment, bash automation, shell script examples, production bash">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Real-World Examples - Bash Tutorial">
    <meta property="og:description" content="Complete, production-ready Bash scripts for common automation tasks.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/practices-examples.jsp">
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
        "name": "Bash Real-World Examples",
        "description": "Production-ready Bash script examples for backup, monitoring, deployment, and automation.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Advanced",
        "teaches": ["Backup scripts", "System monitoring", "Deployment automation", "Log processing", "API integration", "Cron jobs"],
        "timeRequired": "PT35M",
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

<body class="tutorial-body no-preview" data-lesson="practices-examples">
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
                    <span>Real-World Examples</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Real-World Examples</h1>
                    <div class="lesson-meta">
                        <span>Advanced</span>
                        <span>~35 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Theory becomes powerful when applied to real problems. This final lesson presents complete, production-ready scripts that demonstrate everything you've learned. Study these examples, adapt them to your needs, and use them as references for your own projects!</p>

                    <!-- Example 1: Backup Script -->
                    <h2>Example 1: Backup Script</h2>
                    <p>A complete backup system with rotation, compression, and verification.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/practices-examples-backup.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-backup" />
                    </jsp:include>

                    <h3>Key Features</h3>
                    <ul>
                        <li>Configurable via environment or command-line</li>
                        <li>Compression with gzip</li>
                        <li>Automatic rotation of old backups</li>
                        <li>Verification of backup integrity</li>
                        <li>Logging with timestamps</li>
                        <li>Error handling and cleanup</li>
                    </ul>

                    <div class="tip-box">
                        <strong>Cron Setup:</strong> Schedule daily backups with:
                        <pre><code class="language-bash"># /etc/cron.d/backup
0 2 * * * root /opt/scripts/backup.sh -s /var/data -d /backup -r 7 >> /var/log/backup.log 2>&1</code></pre>
                    </div>

                    <!-- Example 2: System Monitor -->
                    <h2>Example 2: System Monitoring</h2>
                    <p>Monitor system resources and send alerts when thresholds are exceeded.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/practices-examples-monitoring.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-monitor" />
                    </jsp:include>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Example 3: Deployment Script -->
                    <h2>Example 3: Deployment Script</h2>
                    <p>Deploy applications with rollback capability.</p>

                    <pre><code class="language-bash">#!/usr/bin/env bash
#
# deploy.sh - Application deployment with rollback
#
set -euo pipefail

readonly SCRIPT_NAME="\$(basename "\$0")"
readonly DEPLOY_DIR="/var/www/app"
readonly RELEASES_DIR="\$DEPLOY_DIR/releases"
readonly CURRENT_LINK="\$DEPLOY_DIR/current"
readonly SHARED_DIR="\$DEPLOY_DIR/shared"
readonly KEEP_RELEASES=5

# Logging
log() { echo "[\$(date '+%Y-%m-%d %H:%M:%S')] \$*"; }
die() { log "ERROR: \$*" >&2; exit 1; }

# Create new release directory
create_release() {
    local release_id="\$(date +%Y%m%d%H%M%S)"
    local release_dir="\$RELEASES_DIR/\$release_id"

    log "Creating release: \$release_id"

    mkdir -p "\$release_dir"
    echo "\$release_dir"
}

# Deploy code to release directory
deploy_code() {
    local release_dir="\$1"
    local source="\${2:-.}"

    log "Deploying code to \$release_dir"

    # Copy application code
    rsync -av --exclude='.git' --exclude='node_modules' \\
        "\$source/" "\$release_dir/"

    # Link shared directories
    ln -sf "\$SHARED_DIR/logs" "\$release_dir/logs"
    ln -sf "\$SHARED_DIR/.env" "\$release_dir/.env"
}

# Switch current symlink to new release
switch_release() {
    local release_dir="\$1"

    log "Switching to release: \$(basename "\$release_dir")"

    ln -sfn "\$release_dir" "\$CURRENT_LINK"
}

# Cleanup old releases
cleanup_old_releases() {
    log "Cleaning up old releases (keeping \$KEEP_RELEASES)"

    local releases=(\$(ls -1t "\$RELEASES_DIR"))
    local to_delete=("\${releases[@]:\$KEEP_RELEASES}")

    for release in "\${to_delete[@]}"; do
        log "Removing old release: \$release"
        rm -rf "\$RELEASES_DIR/\$release"
    done
}

# Rollback to previous release
rollback() {
    local releases=(\$(ls -1t "\$RELEASES_DIR"))

    [[ \${#releases[@]} -lt 2 ]] && die "No previous release to rollback to"

    local previous="\${releases[1]}"
    log "Rolling back to: \$previous"

    switch_release "\$RELEASES_DIR/\$previous"
    log "Rollback complete"
}

# Main deployment
deploy() {
    local source="\${1:-.}"

    log "Starting deployment..."

    # Create release
    local release_dir
    release_dir=\$(create_release)

    # Deploy code
    deploy_code "\$release_dir" "\$source"

    # Run build/install commands
    log "Installing dependencies..."
    (cd "\$release_dir" && npm install --production 2>/dev/null || true)

    # Switch to new release
    switch_release "\$release_dir"

    # Restart service
    log "Restarting application..."
    systemctl restart myapp 2>/dev/null || true

    # Cleanup
    cleanup_old_releases

    log "Deployment complete!"
}

# Parse arguments
case "\${1:-deploy}" in
    deploy)   deploy "\${2:-.}" ;;
    rollback) rollback ;;
    *)        echo "Usage: \$SCRIPT_NAME {deploy|rollback} [source]" ;;
esac</code></pre>

                    <!-- Example 4: Log Processor -->
                    <h2>Example 4: Log Processing</h2>
                    <p>Analyze and report on log files.</p>

                    <pre><code class="language-bash">#!/usr/bin/env bash
#
# log-analyzer.sh - Analyze access logs and generate reports
#
set -euo pipefail

readonly LOG_FILE="\${1:-/var/log/nginx/access.log}"

log() { echo "[\$(date '+%H:%M:%S')] \$*"; }

analyze_logs() {
    [[ -f "\$LOG_FILE" ]] || { echo "Log file not found: \$LOG_FILE"; exit 1; }

    echo "=== Log Analysis Report ==="
    echo "File: \$LOG_FILE"
    echo "Generated: \$(date)"
    echo ""

    # Total requests
    local total=\$(wc -l < "\$LOG_FILE")
    echo "Total Requests: \$total"
    echo ""

    # Requests per status code
    echo "--- Status Codes ---"
    awk '{print \$9}' "\$LOG_FILE" | sort | uniq -c | sort -rn | head -10
    echo ""

    # Top 10 IPs
    echo "--- Top 10 IP Addresses ---"
    awk '{print \$1}' "\$LOG_FILE" | sort | uniq -c | sort -rn | head -10
    echo ""

    # Top 10 URLs
    echo "--- Top 10 URLs ---"
    awk '{print \$7}' "\$LOG_FILE" | sort | uniq -c | sort -rn | head -10
    echo ""

    # Requests per hour
    echo "--- Requests per Hour ---"
    awk '{print \$4}' "\$LOG_FILE" | cut -d: -f2 | sort | uniq -c
    echo ""

    # Error rate
    local errors=\$(awk '\$9 >= 400' "\$LOG_FILE" | wc -l)
    local error_rate=\$(echo "scale=2; \$errors * 100 / \$total" | bc)
    echo "Error Rate: \$error_rate% (\$errors errors)"
}

# Run with error handling
analyze_logs 2>/dev/null || echo "Analysis failed"</code></pre>

                    <!-- Example 5: API Integration -->
                    <h2>Example 5: API Integration</h2>
                    <p>Interact with REST APIs using curl.</p>

                    <pre><code class="language-bash">#!/usr/bin/env bash
#
# api-client.sh - REST API client utilities
#
set -euo pipefail

readonly API_BASE="\${API_BASE:-https://api.example.com}"
readonly API_TOKEN="\${API_TOKEN:?API_TOKEN required}"

# HTTP helper
api_request() {
    local method="\$1"
    local endpoint="\$2"
    local data="\${3:-}"

    local curl_opts=(
        -s
        -X "\$method"
        -H "Authorization: Bearer \$API_TOKEN"
        -H "Content-Type: application/json"
    )

    [[ -n "\$data" ]] && curl_opts+=(-d "\$data")

    local response
    response=\$(curl "\${curl_opts[@]}" "\$API_BASE\$endpoint")
    local status=\$?

    if [[ \$status -ne 0 ]]; then
        echo "Request failed" >&2
        return 1
    fi

    echo "\$response"
}

# GET request
get() {
    api_request GET "\$1"
}

# POST request
post() {
    api_request POST "\$1" "\$2"
}

# List users
list_users() {
    get "/users" | jq -r '.[] | "\\(.id): \\(.name)"'
}

# Create user
create_user() {
    local name="\$1"
    local email="\$2"

    local payload=\$(jq -n --arg n "\$name" --arg e "\$email" \\
        '{name: \$n, email: \$e}')

    post "/users" "\$payload"
}

# Health check
health_check() {
    if get "/health" | jq -e '.status == "ok"' >/dev/null; then
        echo "API is healthy"
        return 0
    else
        echo "API is unhealthy"
        return 1
    fi
}

# Run if executed directly
case "\${1:-}" in
    users)  list_users ;;
    create) create_user "\$2" "\$3" ;;
    health) health_check ;;
    *)      echo "Usage: \$0 {users|create|health}" ;;
esac</code></pre>

                    <!-- Patterns Summary -->
                    <h2>Common Patterns Summary</h2>
                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Pattern</th>
                                <th>Used In</th>
                                <th>Purpose</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>set -euo pipefail</code></td>
                                <td>All scripts</td>
                                <td>Error handling</td>
                            </tr>
                            <tr>
                                <td><code>trap cleanup EXIT</code></td>
                                <td>Backup, Deploy</td>
                                <td>Resource cleanup</td>
                            </tr>
                            <tr>
                                <td><code>log() { ... }</code></td>
                                <td>All scripts</td>
                                <td>Consistent logging</td>
                            </tr>
                            <tr>
                                <td><code>\${VAR:-default}</code></td>
                                <td>All scripts</td>
                                <td>Safe defaults</td>
                            </tr>
                            <tr>
                                <td><code>getopts/case</code></td>
                                <td>Backup, Monitor</td>
                                <td>Argument parsing</td>
                            </tr>
                            <tr>
                                <td><code>readonly</code></td>
                                <td>All scripts</td>
                                <td>Constants</td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- Course Conclusion -->
                    <h2>Congratulations!</h2>
                    <div class="summary-box">
                        <p>You've completed the <strong>Bash Scripting Course</strong>! You now have the skills to:</p>
                        <ul>
                            <li>Write professional, maintainable scripts</li>
                            <li>Handle errors gracefully with proper logging</li>
                            <li>Parse arguments and configuration</li>
                            <li>Test your scripts for reliability</li>
                            <li>Automate real-world tasks like backups and deployments</li>
                        </ul>
                        <p><strong>Keep practicing:</strong> The best way to improve is to write more scripts. Start with small automation tasks and gradually tackle larger projects!</p>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Continue your journey:</p>
                    <ul>
                        <li>Explore the <strong>Advanced Topics</strong> module for regex, sed, and awk</li>
                        <li>Build your own script library from the templates</li>
                        <li>Set up CI/CD for your scripts with automated testing</li>
                        <li>Contribute to open-source projects using your new skills</li>
                    </ul>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="practices-testing.jsp" />
                    <jsp:param name="prevTitle" value="Testing Scripts" />
                    <jsp:param name="nextLink" value="index.jsp" />
                    <jsp:param name="nextTitle" value="Back to Bash Tutorial" />
                    <jsp:param name="currentLessonId" value="practices-examples" />
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
