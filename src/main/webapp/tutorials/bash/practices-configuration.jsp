<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "practices-configuration");
   request.setAttribute("currentModule", "Professional Practices"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Configuration Files - Bash Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn to manage Bash script configuration using files, environment variables, and defaults. Build flexible, configurable shell scripts.">
    <meta name="keywords"
        content="bash configuration, shell script config, bash source file, bash environment variables, bash defaults, dotenv bash">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Configuration Files - Bash Tutorial">
    <meta property="og:description" content="Master configuration management in Bash with files, environment variables, and defaults.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/practices-configuration.jsp">
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
        "name": "Bash Configuration Files",
        "description": "Learn to manage configuration using files, environment variables, and defaults in Bash.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Advanced",
        "teaches": ["Config files", "source command", "Environment variables", "Default values", "Config validation", "Multiple environments"],
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

<body class="tutorial-body no-preview" data-lesson="practices-configuration">
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
                    <span>Configuration Files</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Configuration Files</h1>
                    <div class="lesson-meta">
                        <span>Advanced</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Hardcoding values in scripts is a recipe for maintenance headaches. Professional scripts separate configuration from code, allowing easy customization across environments. This lesson teaches you multiple approaches to configuration management!</p>

                    <!-- Section 1: Sourcing Config Files -->
                    <h2>Sourcing Configuration Files</h2>
                    <p>The simplest approach: store configuration in a Bash file and source it.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/practices-configuration.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-source" />
                    </jsp:include>

                    <h3>Config File Format</h3>
                    <pre><code class="language-bash"># config.sh - Application configuration
# This file is sourced by the main script

# Database settings
DB_HOST="localhost"
DB_PORT=5432
DB_NAME="myapp"
DB_USER="appuser"

# Application settings
APP_ENV="development"
APP_DEBUG=true
APP_LOG_LEVEL="INFO"

# Paths
DATA_DIR="/var/data/myapp"
LOG_DIR="/var/log/myapp"
TEMP_DIR="/tmp/myapp"

# Feature flags
ENABLE_CACHE=true
ENABLE_METRICS=false</code></pre>

                    <div class="info-box">
                        <strong>The source Command:</strong> <code>source file</code> (or <code>. file</code>) executes the file in the current shell, making its variables available. Unlike running a script, sourcing doesn't create a subshell.
                    </div>

                    <!-- Section 2: Environment Variables -->
                    <h2>Environment Variables with Defaults</h2>
                    <p>Environment variables allow runtime configuration without modifying files.</p>

                    <pre><code class="language-bash"># Pattern: Use env var if set, otherwise use default
DB_HOST="\${DB_HOST:-localhost}"
DB_PORT="\${DB_PORT:-5432}"
APP_ENV="\${APP_ENV:-production}"

# Pattern: Require env var (fail if unset)
DB_PASSWORD="\${DB_PASSWORD:?Database password required}"
API_KEY="\${API_KEY:?API key must be set}"

# Pattern: Use env var only if set and non-empty
LOG_FILE="\${LOG_FILE:+\$LOG_FILE}"  # Empty if unset

# Check boolean env vars
if [[ "\${DEBUG:-false}" == "true" ]]; then
    set -x
fi

# Load from .env file (dotenv pattern)
load_dotenv() {
    local env_file="\${1:-.env}"
    if [[ -f "\$env_file" ]]; then
        # Export each line as variable
        set -a  # Auto-export
        source "\$env_file"
        set +a
    fi
}

load_dotenv</code></pre>

                    <h3>Parameter Expansion Reference</h3>
                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Syntax</th>
                                <th>Behavior</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>\${var:-default}</code></td>
                                <td>Use default if var is unset or empty</td>
                            </tr>
                            <tr>
                                <td><code>\${var:=default}</code></td>
                                <td>Set var to default if unset or empty</td>
                            </tr>
                            <tr>
                                <td><code>\${var:?error}</code></td>
                                <td>Exit with error if var is unset or empty</td>
                            </tr>
                            <tr>
                                <td><code>\${var:+value}</code></td>
                                <td>Use value if var IS set and non-empty</td>
                            </tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Config File Formats -->
                    <h2>Parsing Different Config Formats</h2>
                    <p>Sometimes you need to parse INI files, YAML, or other formats.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/practices-configuration-parse.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-parse" />
                    </jsp:include>

                    <h3>Common Formats</h3>
                    <pre><code class="language-bash"># Simple key=value parser
parse_config() {
    local file="\$1"
    while IFS='=' read -r key value; do
        # Skip comments and empty lines
        [[ "\$key" =~ ^[[:space:]]*# ]] && continue
        [[ -z "\$key" ]] && continue

        # Trim whitespace
        key="\$(echo "\$key" | xargs)"
        value="\$(echo "\$value" | xargs)"

        # Remove quotes
        value="\${value#[\"\']}"
        value="\${value%[\"\']}"

        # Export as variable
        export "\$key=\$value"
    done < "\$file"
}

# INI file parser (with sections)
parse_ini() {
    local file="\$1"
    local section=""

    while IFS= read -r line; do
        # Skip comments and empty lines
        [[ "\$line" =~ ^[[:space:]]*[#\;] ]] && continue
        [[ -z "\${line// }" ]] && continue

        # Section header
        if [[ "\$line" =~ ^\[([^\]]+)\] ]]; then
            section="\${BASH_REMATCH[1]}_"
            continue
        fi

        # Key=value
        if [[ "\$line" =~ ^([^=]+)=(.*)$ ]]; then
            local key="\${section}\${BASH_REMATCH[1]}"
            local value="\${BASH_REMATCH[2]}"
            key="\$(echo "\$key" | xargs | tr '[:lower:]' '[:upper:]')"
            export "\$key=\$value"
        fi
    done < "\$file"
}

# Usage with INI:
# [database]
# host=localhost
# port=5432
# -> DATABASE_HOST=localhost, DATABASE_PORT=5432</code></pre>

                    <!-- Section 4: Configuration Hierarchy -->
                    <h2>Configuration Hierarchy</h2>
                    <p>Professional scripts support multiple config sources with clear precedence.</p>

                    <pre><code class="language-bash"># Load configuration with precedence:
# 1. Built-in defaults (lowest)
# 2. System config file
# 3. User config file
# 4. Environment variables
# 5. Command-line arguments (highest)

load_config() {
    # 1. Defaults
    DB_HOST="localhost"
    DB_PORT=5432
    APP_ENV="production"

    # 2. System config
    [[ -f "/etc/myapp/config" ]] && source "/etc/myapp/config"

    # 3. User config
    [[ -f "\$HOME/.myapprc" ]] && source "\$HOME/.myapprc"

    # 4. Local project config
    [[ -f "./.myapp.conf" ]] && source "./.myapp.conf"

    # 5. Environment overrides
    DB_HOST="\${MYAPP_DB_HOST:-\$DB_HOST}"
    DB_PORT="\${MYAPP_DB_PORT:-\$DB_PORT}"
    APP_ENV="\${MYAPP_ENV:-\$APP_ENV}"

    # 6. Command-line args override in parse_args()
}

# Environment-specific configs
load_environment_config() {
    local env="\${APP_ENV:-production}"
    local config_dir="\${CONFIG_DIR:-/etc/myapp}"

    # Load base config
    [[ -f "\$config_dir/config.sh" ]] && source "\$config_dir/config.sh"

    # Load environment-specific overrides
    [[ -f "\$config_dir/config.\$env.sh" ]] && source "\$config_dir/config.\$env.sh"
}</code></pre>

                    <div class="tip-box">
                        <strong>12-Factor App:</strong> The 12-factor methodology recommends storing config in environment variables. This works well for containerized applications and CI/CD pipelines.
                    </div>

                    <!-- Section 5: Config Validation -->
                    <h2>Configuration Validation</h2>
                    <p>Always validate configuration before using it.</p>

                    <pre><code class="language-bash"># Validate required settings
validate_config() {
    local errors=0

    # Required variables
    for var in DB_HOST DB_USER DB_PASSWORD; do
        if [[ -z "\${!var}" ]]; then
            echo "ERROR: \$var is required" >&2
            ((errors++))
        fi
    done

    # Numeric validation
    if [[ ! "\$DB_PORT" =~ ^[0-9]+$ ]]; then
        echo "ERROR: DB_PORT must be a number" >&2
        ((errors++))
    fi

    # Range validation
    if [[ \$DB_PORT -lt 1 || \$DB_PORT -gt 65535 ]]; then
        echo "ERROR: DB_PORT must be 1-65535" >&2
        ((errors++))
    fi

    # Path validation
    if [[ ! -d "\$DATA_DIR" ]]; then
        echo "ERROR: DATA_DIR does not exist: \$DATA_DIR" >&2
        ((errors++))
    fi

    # Enum validation
    case "\$APP_ENV" in
        development|staging|production) ;;
        *)
            echo "ERROR: APP_ENV must be development, staging, or production" >&2
            ((errors++))
            ;;
    esac

    return \$errors
}

# Print current configuration
print_config() {
    echo "=== Current Configuration ==="
    echo "DB_HOST=\$DB_HOST"
    echo "DB_PORT=\$DB_PORT"
    echo "DB_NAME=\$DB_NAME"
    echo "DB_USER=\$DB_USER"
    echo "DB_PASSWORD=****"  # Don't print passwords!
    echo "APP_ENV=\$APP_ENV"
    echo "DATA_DIR=\$DATA_DIR"
}</code></pre>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Sourcing untrusted config files</h4>
                        <pre><code class="language-bash"># Dangerous - config could run arbitrary code!
source "\$USER_PROVIDED_CONFIG"

# Safer - parse key=value only
while IFS='=' read -r key value; do
    # Validate key name
    [[ "\$key" =~ ^[A-Z_][A-Z0-9_]*$ ]] || continue
    declare "\$key=\$value"
done < "\$config"</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. No default values</h4>
                        <pre><code class="language-bash"># Wrong - fails if not set
process --host "\$DB_HOST"

# Correct - provide defaults
DB_HOST="\${DB_HOST:-localhost}"
process --host "\$DB_HOST"</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Hardcoding paths</h4>
                        <pre><code class="language-bash"># Wrong - not portable
CONFIG_FILE="/home/john/myapp/config"

# Correct - use variables
CONFIG_FILE="\${HOME}/.config/myapp/config"
CONFIG_FILE="\${XDG_CONFIG_HOME:-\$HOME/.config}/myapp/config"</code></pre>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>source:</strong> Load config from Bash files with <code>source config.sh</code></li>
                            <li><strong>Defaults:</strong> Always provide defaults with <code>\${VAR:-default}</code></li>
                            <li><strong>Hierarchy:</strong> Support multiple sources with clear precedence</li>
                            <li><strong>Validation:</strong> Always validate config before use</li>
                            <li><strong>Security:</strong> Never source untrusted files; parse instead</li>
                            <li><strong>Secrets:</strong> Use environment variables for passwords/tokens</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now let's master <strong>Command Line Arguments</strong>. You'll learn to parse flags and options using <code>getopts</code> and build professional CLIs!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="practices-logging.jsp" />
                    <jsp:param name="prevTitle" value="Logging" />
                    <jsp:param name="nextLink" value="practices-arguments.jsp" />
                    <jsp:param name="nextTitle" value="Command Line Arguments" />
                    <jsp:param name="currentLessonId" value="practices-configuration" />
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
