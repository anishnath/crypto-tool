<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "variables-expansion");
   request.setAttribute("currentModule", "Variables & Environment"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Bash Variable Expansion - Default Values, Error Handling, String Length | 8gwifi.org</title>
    <meta name="description"
        content="Master Bash variable expansion techniques: default values (\${var:-default}), error handling (\${var:?error}), string length (\${#var}), and substring operations.">
    <meta name="keywords"
        content="bash variable expansion, bash default values, \${var:-default}, bash string length, bash substring, bash parameter expansion, bash variables">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Bash Variable Expansion - Default Values, Error Handling, String Length">
    <meta property="og:description" content="Master powerful Bash variable expansion techniques for default values, error handling, and string manipulation.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/variables-expansion.jsp">
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
        "name": "Bash Variable Expansion",
        "description": "Master Bash variable expansion: default values, error handling, string length, and substring operations.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Default value expansion", "\${var:-default}", "\${var:=default}", "\${var:?error}", "String length \${#var}", "Substring expansion", "Parameter expansion"],
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

<body class="tutorial-body no-preview" data-lesson="variables-expansion">
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
                    <span>Variable Expansion</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Variable Expansion</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~20 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Variable expansion is one of Bash's most powerful features. It allows you to provide default values, handle unset variables gracefully, get string lengths, extract substrings, and much more. These techniques make your scripts more robust and handle edge cases elegantly. Once you master variable expansion, you'll write more reliable and concise Bash scripts!</p>

                    <!-- Section 1: Why Use Braces -->
                    <h2>Why Use Braces: \${var}</h2>
                    <p>While <code>$var</code> works in many cases, using braces <code>\${var}</code> is often clearer and sometimes required. Braces help Bash understand where the variable name ends.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/variables-expansion.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-expansion" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>When Braces Are Required:</strong><br>
                        - Concatenation: <code>\${name}_file</code> (not <code>$name_file</code>)<br>
                        - Default values: <code>\${var:-default}</code><br>
                        - String manipulation: <code>\${var#pattern}</code><br>
                        - Array access: <code>\${array[0]}</code>
                    </div>

                    <!-- Section 2: Default Value Expansion -->
                    <h2>Default Value Expansion</h2>
                    <p>One of the most useful expansion techniques is providing default values when a variable is unset or empty. This prevents errors and makes scripts more user-friendly.</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Syntax</th>
                                <th>Description</th>
                                <th>Example</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>\${var:-default}</code></td>
                                <td>Use default if var is unset or empty</td>
                                <td><code>\${name:-Guest}</code> → "Guest" if name is unset</td>
                            </tr>
                            <tr>
                                <td><code>\${var:=default}</code></td>
                                <td>Assign default if var is unset or empty</td>
                                <td><code>\${count:=0}</code> → sets count to 0 if unset</td>
                            </tr>
                            <tr>
                                <td><code>\${var:?error}</code></td>
                                <td>Error with message if var is unset or empty</td>
                                <td><code>\${USER:?Not logged in}</code> → exits if USER unset</td>
                            </tr>
                            <tr>
                                <td><code>\${var:+value}</code></td>
                                <td>Use value if var is set (not default)</td>
                                <td><code>\${DEBUG:+yes}</code> → "yes" if DEBUG is set</td>
                            </tr>
                        </tbody>
                    </table>

                    <pre><code class="language-bash"># Example: Using default values
name=""  # Empty string
echo "Hello, \${name:-Guest}"  # Output: Hello, Guest

# Example: Assigning default
unset port
echo "Port: \${port:=8080}"  # Output: Port: 8080, and port is now set to 8080
echo "Port is now: $port"   # Output: Port is now: 8080

# Example: Error if required
# USER="\${USER:?User must be set}"  # Exits with error if USER unset</code></pre>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Use <code>\${var:-default}</code> to provide sensible defaults in scripts. This makes your scripts work even when users don't set optional variables. For example: <code>\${PORT:-8080}</code> uses port 8080 if not specified.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: String Length -->
                    <h2>String Length: \${#var}</h2>
                    <p>Get the length of a string using <code>\${#var}</code>. This is useful for validation, formatting, and string manipulation.</p>

                    <pre><code class="language-bash">text="Hello World"
echo \${#text}  # Output: 11

# Practical example: Validate minimum length
password="abc"
if [ \${#password} -lt 8 ]; then
    echo "Password too short!"
fi</code></pre>

                    <!-- Section 4: Substring Expansion -->
                    <h2>Substring Expansion: \${var:offset:length}</h2>
                    <p>Extract portions of a string using substring expansion. This is useful for parsing text and extracting specific parts.</p>

                    <pre><code class="language-bash">text="Hello World"

# Extract substring
echo \${text:0:5}    # Output: Hello (from index 0, length 5)
echo \${text:6}      # Output: World (from index 6 to end)
echo \${text: -5}    # Output: World (last 5 chars, note space before -)
echo \${text:6:3}    # Output: Wor (from index 6, length 3)</code></pre>

                    <div class="warning-box">
                        <strong>Important:</strong> Negative indices require a space before the minus sign! <code>\${text:-5}</code> would use default value syntax, while <code>\${text: -5}</code> gets the last 5 characters.
                    </div>

                    <!-- Section 5: Practical Examples -->
                    <h2>Practical Examples</h2>
                    <p>Here are real-world scenarios where variable expansion shines:</p>

                    <pre><code class="language-bash">#!/bin/bash
# Configuration with defaults
PORT="\${PORT:-8080}"
HOST="\${HOST:-localhost}"
DEBUG="\${DEBUG:-false}"

echo "Server: $HOST:$PORT"
[ "$DEBUG" = "true" ] && echo "Debug mode enabled"

# Validate required variable
API_KEY="\${API_KEY:?API_KEY environment variable is required}"
echo "API Key: \${API_KEY:0:8}..."  # Show only first 8 chars for security</code></pre>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Confusing := and :- operators</h4>
                        <pre><code class="language-bash"># :- uses default but doesn't assign
unset port
echo "Port: \${port:-8080}"  # Uses 8080 but port still unset
echo "port=$port"  # Empty

# := assigns default
unset port
echo "Port: \${port:=8080}"  # Uses 8080 AND assigns it
echo "port=$port"  # 8080</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Missing space before negative offset</h4>
                        <pre><code class="language-bash">text="Hello World"

# Wrong - interpreted as default value syntax
echo \${text:-5}  # Output: Hello World (not last 5 chars!)

# Correct - space before minus
echo \${text: -5}  # Output: World</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Not understanding :+ operator</h4>
                        <pre><code class="language-bash"># :+ is the opposite of :-
# It uses the value if variable IS set (not when unset)

DEBUG="true"
echo \${DEBUG:+enabled}  # Output: enabled (DEBUG is set)

unset DEBUG
echo \${DEBUG:+enabled}  # Output: (empty, because DEBUG is unset)</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Use Variable Expansion</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a script that demonstrates variable expansion techniques!</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Create a variable for username with a default value of "Guest"</li>
                            <li>Create a port variable that defaults to 8080 if not set, and assign it</li>
                            <li>Create a text variable and display its length</li>
                            <li>Extract the first 3 characters and last 3 characters from the text</li>
                            <li>Use <code>\${var:?}</code> to ensure a required variable is set</li>
                        </ul>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-bash">#!/bin/bash
# Variable expansion exercise

# Default value (doesn't assign)
unset username
echo "User: \${username:-Guest}"  # Uses default
echo "username is still: '\${username:-unset}'"  # Still unset

# Assign default value
unset port
echo "Port: \${port:=8080}"  # Assigns default
echo "port is now: $port"   # Now set

# String length
text="Hello World"
echo "Text: '$text'"
echo "Length: \${#text}"

# Substring extraction
echo "First 3 chars: \${text:0:3}"
echo "Last 3 chars: \${text: -3}"

# Error if required variable unset
required="\${REQUIRED:?REQUIRED variable must be set}"
echo "Required: $required"</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Braces:</strong> <code>\${var}</code> is clearer and sometimes required</li>
                            <li><strong>Default Value:</strong> <code>\${var:-default}</code> uses default if unset/empty</li>
                            <li><strong>Assign Default:</strong> <code>\${var:=default}</code> assigns and uses default</li>
                            <li><strong>Error if Unset:</strong> <code>\${var:?error}</code> exits with error if unset</li>
                            <li><strong>If Set:</strong> <code>\${var:+value}</code> uses value if var is set</li>
                            <li><strong>String Length:</strong> <code>\${#var}</code> returns the length</li>
                            <li><strong>Substring:</strong> <code>\${var:offset:length}</code> extracts substring</li>
                            <li><strong>Negative Offset:</strong> Use space before minus: <code>\${var: -5}</code></li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Excellent! You've learned powerful variable expansion techniques. Next, we'll explore <strong>Environment Variables</strong> - special variables that are available to all processes, like <code>PATH</code>, <code>HOME</code>, and <code>USER</code>. Understanding environment variables is crucial for system administration and cross-process communication!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="variables-basics.jsp" />
                    <jsp:param name="prevTitle" value="Variables" />
                    <jsp:param name="nextLink" value="variables-environment.jsp" />
                    <jsp:param name="nextTitle" value="Environment Variables" />
                    <jsp:param name="currentLessonId" value="variables-expansion" />
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

