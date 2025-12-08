<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "practices-arguments");
   request.setAttribute("currentModule", "Professional Practices"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Command Line Arguments - Bash Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn to parse command line arguments in Bash using getopts, handling flags, options, and building professional CLI interfaces.">
    <meta name="keywords"
        content="bash getopts, bash command line arguments, bash flags, bash options parsing, shell script arguments, bash CLI">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Command Line Arguments - Bash Tutorial">
    <meta property="og:description" content="Master argument parsing with getopts for professional command-line tools.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/practices-arguments.jsp">
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
        "name": "Bash Command Line Arguments",
        "description": "Learn to parse command line arguments using getopts and build professional CLI tools.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Advanced",
        "teaches": ["getopts", "Argument parsing", "Flags and options", "Usage messages", "Long options", "Positional arguments"],
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

<body class="tutorial-body no-preview" data-lesson="practices-arguments">
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
                    <span>Command Line Arguments</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Command Line Arguments</h1>
                    <div class="lesson-meta">
                        <span>Advanced</span>
                        <span>~30 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Professional command-line tools accept arguments and options that control their behavior. This lesson teaches you to parse arguments using <code>getopts</code>, handle flags and options, and create user-friendly CLI interfaces that follow Unix conventions!</p>

                    <!-- Section 1: Basic Arguments -->
                    <h2>Positional Arguments</h2>
                    <p>Start with the basics: accessing arguments passed to your script.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/practices-arguments.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-basic" />
                    </jsp:include>

                    <h3>Special Variables</h3>
                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Variable</th>
                                <th>Meaning</th>
                                <th>Example</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>\$0</code></td>
                                <td>Script name</td>
                                <td><code>./backup.sh</code></td>
                            </tr>
                            <tr>
                                <td><code>\$1, \$2...</code></td>
                                <td>Positional arguments</td>
                                <td>First arg, second arg...</td>
                            </tr>
                            <tr>
                                <td><code>\$#</code></td>
                                <td>Number of arguments</td>
                                <td><code>3</code></td>
                            </tr>
                            <tr>
                                <td><code>\$@</code></td>
                                <td>All arguments (separate words)</td>
                                <td><code>"a" "b" "c"</code></td>
                            </tr>
                            <tr>
                                <td><code>\$*</code></td>
                                <td>All arguments (single string)</td>
                                <td><code>"a b c"</code></td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="info-box">
                        <strong>Always quote \$@:</strong> Use <code>"\$@"</code> to preserve arguments with spaces. <code>for arg in "\$@"; do</code> handles "hello world" as one argument.
                    </div>

                    <!-- Section 2: getopts -->
                    <h2>Parsing with getopts</h2>
                    <p>The <code>getopts</code> builtin handles short options like <code>-v</code>, <code>-f file</code>.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/practices-arguments-getopts.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-getopts" />
                    </jsp:include>

                    <h3>getopts Syntax</h3>
                    <pre><code class="language-bash"># getopts OPTSTRING VARNAME [ARGS]
#
# OPTSTRING format:
#   "vhf:"
#   v     - Flag (no argument)
#   h     - Flag (no argument)
#   f:    - Option (requires argument)
#   :     - Leading colon enables silent error mode

while getopts ":vhf:o:" opt; do
    case \$opt in
        v) verbose=true ;;
        h) show_help; exit 0 ;;
        f) input_file="\$OPTARG" ;;
        o) output_file="\$OPTARG" ;;
        :) echo "Option -\$OPTARG requires an argument" >&2; exit 1 ;;
        \\?) echo "Invalid option: -\$OPTARG" >&2; exit 1 ;;
    esac
done

# Shift processed options away
shift \$((OPTIND - 1))

# Remaining arguments are in \$@
echo "Remaining args: \$@"</code></pre>

                    <div class="tip-box">
                        <strong>OPTIND:</strong> After <code>getopts</code>, use <code>shift \$((OPTIND - 1))</code> to remove processed options. Remaining positional arguments are then in <code>\$1, \$2, ...</code>
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Long Options -->
                    <h2>Handling Long Options</h2>
                    <p>For <code>--verbose</code> style options, use manual parsing or external tools.</p>

                    <pre><code class="language-bash"># Manual long option parsing
parse_args() {
    while [[ \$# -gt 0 ]]; do
        case \$1 in
            -v|--verbose)
                verbose=true
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            -f|--file)
                input_file="\$2"
                shift 2
                ;;
            --file=*)
                input_file="\${1#*=}"
                shift
                ;;
            -o|--output)
                output_file="\$2"
                shift 2
                ;;
            --output=*)
                output_file="\${1#*=}"
                shift
                ;;
            --)
                shift
                break
                ;;
            -*)
                echo "Unknown option: \$1" >&2
                exit 1
                ;;
            *)
                # Positional argument
                positional+=("\$1")
                shift
                ;;
        esac
    done

    # Set remaining positional args
    set -- "\${positional[@]}"
}

# Usage: script.sh --verbose --file=data.txt output.txt
parse_args "\$@"</code></pre>

                    <h3>Option Styles</h3>
                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Style</th>
                                <th>Example</th>
                                <th>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Short flag</td>
                                <td><code>-v</code></td>
                                <td>Boolean, no value</td>
                            </tr>
                            <tr>
                                <td>Short with value</td>
                                <td><code>-f file.txt</code></td>
                                <td>Space-separated</td>
                            </tr>
                            <tr>
                                <td>Combined shorts</td>
                                <td><code>-vf file.txt</code></td>
                                <td>Multiple flags</td>
                            </tr>
                            <tr>
                                <td>Long flag</td>
                                <td><code>--verbose</code></td>
                                <td>Boolean, no value</td>
                            </tr>
                            <tr>
                                <td>Long with value</td>
                                <td><code>--file file.txt</code></td>
                                <td>Space-separated</td>
                            </tr>
                            <tr>
                                <td>Long with equals</td>
                                <td><code>--file=file.txt</code></td>
                                <td>Equals-separated</td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- Section 4: Usage Messages -->
                    <h2>Professional Usage Messages</h2>
                    <p>Good CLI tools provide helpful usage information.</p>

                    <pre><code class="language-bash">#!/usr/bin/env bash

readonly SCRIPT_NAME="\$(basename "\$0")"
readonly VERSION="1.0.0"

show_help() {
    cat << EOF
Usage: \$SCRIPT_NAME [OPTIONS] <source> <destination>

Copy files with advanced options.

Arguments:
    source          Source file or directory
    destination     Destination path

Options:
    -r, --recursive     Copy directories recursively
    -f, --force         Overwrite existing files
    -v, --verbose       Show detailed output
    -n, --dry-run       Show what would be done
    -h, --help          Show this help message
    --version           Show version number

Examples:
    \$SCRIPT_NAME file.txt backup/
    \$SCRIPT_NAME -rv src/ dest/
    \$SCRIPT_NAME --force --verbose data.db /backup/

Environment:
    COPY_OPTS       Default options (e.g., "-rv")

Exit Codes:
    0   Success
    1   General error
    2   Invalid arguments

Report bugs to: bugs@example.com
EOF
}

show_version() {
    echo "\$SCRIPT_NAME version \$VERSION"
}

# Parse -h and --version early
case "\${1:-}" in
    -h|--help)    show_help; exit 0 ;;
    --version)    show_version; exit 0 ;;
esac</code></pre>

                    <!-- Section 5: Complete Example -->
                    <h2>Complete Argument Parser</h2>
                    <p>Putting it all together: a robust argument parsing template.</p>

                    <pre><code class="language-bash">#!/usr/bin/env bash
set -euo pipefail

# Script info
readonly SCRIPT_NAME="\$(basename "\$0")"
readonly SCRIPT_DIR="\$(cd "\$(dirname "\$0")" && pwd)"

# Defaults
verbose=false
dry_run=false
force=false
output_file=""
declare -a input_files=()

show_help() {
    cat << EOF
Usage: \$SCRIPT_NAME [OPTIONS] FILE...

Process one or more files.

Options:
    -o, --output FILE   Output file (default: stdout)
    -f, --force         Overwrite existing output
    -n, --dry-run       Show what would be done
    -v, --verbose       Verbose output
    -h, --help          Show this help
EOF
}

die() {
    echo "Error: \$*" >&2
    echo "Try '\$SCRIPT_NAME --help' for more information." >&2
    exit 1
}

parse_args() {
    while [[ \$# -gt 0 ]]; do
        case \$1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--verbose)
                verbose=true
                shift
                ;;
            -n|--dry-run)
                dry_run=true
                shift
                ;;
            -f|--force)
                force=true
                shift
                ;;
            -o|--output)
                [[ \$# -lt 2 ]] && die "Option \$1 requires an argument"
                output_file="\$2"
                shift 2
                ;;
            --output=*)
                output_file="\${1#*=}"
                shift
                ;;
            --)
                shift
                input_files+=("\$@")
                break
                ;;
            -*)
                die "Unknown option: \$1"
                ;;
            *)
                input_files+=("\$1")
                shift
                ;;
        esac
    done
}

validate_args() {
    # Require at least one input file
    [[ \${#input_files[@]} -eq 0 ]] && die "No input files specified"

    # Check input files exist
    for file in "\${input_files[@]}"; do
        [[ -f "\$file" ]] || die "File not found: \$file"
    done

    # Check output won't overwrite without --force
    if [[ -n "\$output_file" && -f "\$output_file" && "\$force" != "true" ]]; then
        die "Output file exists: \$output_file (use --force to overwrite)"
    fi
}

main() {
    parse_args "\$@"
    validate_args

    [[ "\$verbose" == "true" ]] && echo "Processing \${#input_files[@]} file(s)..."

    for file in "\${input_files[@]}"; do
        [[ "\$verbose" == "true" ]] && echo "  Processing: \$file"
        # Process file...
    done

    echo "Done!"
}

main "\$@"</code></pre>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Not quoting \$@</h4>
                        <pre><code class="language-bash"># Wrong - breaks on spaces
for arg in \$@; do echo "\$arg"; done

# Correct
for arg in "\$@"; do echo "\$arg"; done</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Missing required argument check</h4>
                        <pre><code class="language-bash"># Wrong - crashes if no \$2
-f) file="\$2"; shift 2 ;;

# Correct
-f)
    [[ \$# -lt 2 ]] && die "-f requires an argument"
    file="\$2"
    shift 2
    ;;</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Forgetting to shift</h4>
                        <pre><code class="language-bash"># Wrong - infinite loop!
-v) verbose=true ;;

# Correct
-v) verbose=true; shift ;;</code></pre>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Positional:</strong> Access with <code>\$1, \$2, \$@, \$#</code></li>
                            <li><strong>getopts:</strong> Use for short options (<code>-v, -f file</code>)</li>
                            <li><strong>Long options:</strong> Parse manually with while/case loop</li>
                            <li><strong>Always quote:</strong> Use <code>"\$@"</code> to preserve spaces</li>
                            <li><strong>shift:</strong> Remove processed arguments with shift</li>
                            <li><strong>Help:</strong> Always provide <code>-h/--help</code> with clear usage</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Now let's create reusable <strong>Script Templates</strong>. You'll learn standard boilerplate patterns that you can use as starting points for new scripts!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="practices-configuration.jsp" />
                    <jsp:param name="prevTitle" value="Configuration Files" />
                    <jsp:param name="nextLink" value="practices-templates.jsp" />
                    <jsp:param name="nextTitle" value="Script Templates" />
                    <jsp:param name="currentLessonId" value="practices-arguments" />
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
