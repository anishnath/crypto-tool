<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "strings-heredoc");
   request.setAttribute("currentModule", "Strings & Text Processing"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Here Documents - Bash Tutorial | 8gwifi.org</title>
    <meta name="description"
        content="Learn Bash here documents (heredoc) and here strings. Master multi-line text blocks, variable expansion in heredocs, and practical uses for configuration files and scripts.">
    <meta name="keywords"
        content="bash heredoc, bash here document, bash here string, bash <<EOF, bash multi-line strings, bash script generation">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Here Documents - Bash Tutorial">
    <meta property="og:description" content="Master Bash here documents and here strings for handling multi-line text blocks efficiently.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/strings-heredoc.jsp">
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
        "name": "Bash Here Documents",
        "description": "Learn Bash here documents (heredoc) and here strings for handling multi-line text blocks and script generation.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Here documents", "<<EOF syntax", "Here strings <<<", "Variable expansion in heredocs", "Quoted delimiters", "Practical heredoc uses"],
        "timeRequired": "PT15M",
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

<body class="tutorial-body no-preview" data-lesson="strings-heredoc">
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
                    <span>Here Documents</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Here Documents</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~15 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Here documents (heredocs) are a convenient way to handle multi-line text blocks in Bash scripts. They're perfect for generating configuration files, creating SQL queries, writing multi-line messages, and passing large text blocks to commands. Here strings are a related feature for single-line text input. Both features make your scripts cleaner and more readable!</p>

                    <!-- Section 1: Basic Here Document -->
                    <h2>Basic Here Document Syntax</h2>
                    <p>A here document starts with <code>&lt;&lt;</code> followed by a delimiter (commonly <code>EOF</code> for "End Of File"). Everything until the delimiter is treated as input to the command.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/strings-heredoc.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-heredoc" />
                    </jsp:include>

                    <pre><code class="language-bash"># Basic heredoc syntax
command <<DELIMITER
text line 1
text line 2
text line 3
DELIMITER

# Common delimiter is EOF
cat <<EOF
This is line 1
This is line 2
This is line 3
EOF</code></pre>

                    <div class="info-box">
                        <strong>Key Points:</strong><br>
                        - The delimiter can be any word (EOF, END, STOP, etc.)<br>
                        - The ending delimiter must be on a line by itself, with no leading/trailing spaces<br>
                        - Variables and command substitution are expanded by default<br>
                        - Heredocs work with any command that reads from stdin
                    </div>

                    <!-- Section 2: Variable Expansion in Heredocs -->
                    <h2>Variable Expansion in Heredocs</h2>
                    <p>By default, variables and command substitutions are expanded in here documents, making them perfect for templates!</p>

                    <pre><code class="language-bash">name="Alice"
age=25

cat <<EOF
Hello, my name is $name.
I am $age years old.
Today is $(date +%Y-%m-%d).
EOF

# Output:
# Hello, my name is Alice.
# I am 25 years old.
# Today is 2024-01-15.</code></pre>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Heredocs are excellent for generating configuration files, SQL queries, HTML templates, and email messages where you need variable substitution!
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Quoted Delimiters (No Expansion) -->
                    <h2>Quoted Delimiters (No Expansion)</h2>
                    <p>If you quote the delimiter (with single or double quotes, or a backslash), variable expansion is disabled. This is useful when you want literal text.</p>

                    <pre><code class="language-bash">name="Alice"

# With expansion (default)
cat <<EOF
Name: $name
EOF
# Output: Name: Alice

# Without expansion (quoted delimiter)
cat <<'EOF'
Name: $name
EOF
# Output: Name: $name (literal)

# Or use backslash
cat <<\EOF
Name: $name
EOF
# Output: Name: $name (literal)</code></pre>

                    <div class="warning-box">
                        <strong>Important:</strong> Use quoted delimiters (<code>&lt;&lt;'EOF'</code> or <code>&lt;&lt;\EOF</code>) when generating scripts, config files with literal dollar signs, or when you want to preserve special characters exactly as written.
                    </div>

                    <!-- Section 4: Here Strings -->
                    <h2>Here Strings: &lt;&lt;&lt;</h2>
                    <p>Here strings are a shorthand way to pass a single string to a command's stdin. They're useful for quick one-liners.</p>

                    <pre><code class="language-bash"># Here string syntax: <<< "text"

# Convert to uppercase
tr 'a-z' 'A-Z' <<< "hello world"
# Output: HELLO WORLD

# Pass to grep
grep "error" <<< "This line has an error message"

# Pass variable to command
text="Hello World"
wc -w <<< "$text"
# Output: 2</code></pre>

                    <div class="info-box">
                        <strong>Use Cases:</strong><br>
                        - Quick text processing with commands like <code>tr</code>, <code>grep</code>, <code>sed</code><br>
                        - Testing commands with sample input<br>
                        - Passing variables to commands that expect stdin<br>
                        - One-liners without creating files
                    </div>

                    <!-- Section 5: Practical Examples -->
                    <h2>Practical Examples</h2>
                    <p>Here documents shine in real-world scenarios. Here are some common use cases:</p>

                    <pre><code class="language-bash"># 1. Generate configuration file
cat > /tmp/config.txt <<EOF
server_name=$HOSTNAME
port=8080
debug=true
log_level=INFO
EOF

# 2. Create SQL query
username="alice"
sql_query=$(cat <<EOF
SELECT * FROM users 
WHERE username = '$username'
AND active = 1;
EOF
)

# 3. Send email (conceptual)
mail -s "Report" user@example.com <<EOF
Hello,

This is your daily report for $(date +%Y-%m-%d).

Regards,
System
EOF

# 4. Generate script
cat > deploy.sh <<'EOF'
#!/bin/bash
# Auto-generated deployment script
echo "Deploying application..."
# More commands here
EOF
chmod +x deploy.sh</code></pre>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Spaces around delimiter</h4>
                        <pre><code class="language-bash"># Wrong - spaces break the delimiter
cat <<EOF
text
EOF    # Space before EOF causes error

# Correct - no spaces
cat <<EOF
text
EOF</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Using wrong delimiter</h4>
                        <pre><code class="language-bash"># Wrong - delimiter mismatch
cat <<START
text
END    # Error: expecting START, found END

# Correct - matching delimiters
cat <<START
text
START</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Forgetting to quote when needed</h4>
                        <pre><code class="language-bash"># Wrong - unwanted expansion when generating script
cat > script.sh <<EOF
#!/bin/bash
echo "Price: \$10"  # This becomes $10 (empty variable)
EOF

# Correct - quote delimiter to preserve $
cat > script.sh <<'EOF'
#!/bin/bash
echo "Price: \$10"  # This stays as $10 (literal)
EOF</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Generate a Configuration File</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Use a here document to generate a configuration file!</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Create a config file with at least 3 settings</li>
                            <li>Use variables for at least one setting</li>
                            <li>Include a comment in the config file</li>
                            <li>Use a here string to count words in a message</li>
                        </ul>

                        <p><strong>Hint:</strong> Remember to use quoted delimiter if you want literal dollar signs in your config!</p>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-bash">#!/bin/bash
# Generate configuration file

# Variables for config
APP_NAME="MyApp"
PORT=8080

# Create config file with heredoc
cat > app.conf <<EOF
# Application Configuration
app_name=$APP_NAME
port=$PORT
debug=false
log_level=INFO
EOF

echo "Config file created:"
cat app.conf

# Use here string to count words
message="This is a test message"
word_count=$(wc -w <<< "$message")
echo ""
echo "Word count: $word_count"</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Here Document:</strong> <code>&lt;&lt;DELIMITER</code> ... <code>DELIMITER</code> for multi-line text blocks</li>
                            <li><strong>Variable Expansion:</strong> Variables expand by default in heredocs (perfect for templates)</li>
                            <li><strong>Quoted Delimiter:</strong> Use <code>&lt;&lt;'EOF'</code> or <code>&lt;&lt;\EOF</code> to disable expansion</li>
                            <li><strong>Here String:</strong> <code>&lt;&lt;&lt; "text"</code> for single-line input</li>
                            <li><strong>Delimiter Rules:</strong> Must match exactly, no spaces, on its own line</li>
                            <li><strong>Use Cases:</strong> Config files, SQL queries, script generation, email templates</li>
                            <li><strong>Common Delimiters:</strong> EOF, END, STOP (use descriptive names for clarity)</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Excellent! You've completed the Strings & Text Processing module. Next, we'll move on to <strong>Operators & Arithmetic</strong> - learning how to perform mathematical operations, comparisons, logical operations, and test file properties. These are essential for conditionals and calculations in your scripts!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="strings-parameter-expansion.jsp" />
                    <jsp:param name="prevTitle" value="Parameter Expansion" />
                    <jsp:param name="nextLink" value="operators-arithmetic.jsp" />
                    <jsp:param name="nextTitle" value="Arithmetic Operations" />
                    <jsp:param name="currentLessonId" value="strings-heredoc" />
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

