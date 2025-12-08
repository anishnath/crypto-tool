<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "variables-environment");
   request.setAttribute("currentModule", "Variables & Environment"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Bash Environment Variables - PATH, HOME, USER, Export, env | 8gwifi.org</title>
    <meta name="description"
        content="Learn Bash environment variables: PATH, HOME, USER, SHELL. Understand export, env, printenv commands, and how to set environment variables for your scripts.">
    <meta name="keywords"
        content="bash environment variables, PATH variable, export bash, bash env, printenv, bash HOME USER, bash environment">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Bash Environment Variables - PATH, HOME, USER, Export, env">
    <meta property="og:description" content="Master environment variables in Bash. Learn about PATH, HOME, USER, and how to export variables for child processes.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/variables-environment.jsp">
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
        "name": "Bash Environment Variables",
        "description": "Learn environment variables in Bash: PATH, HOME, USER, SHELL. Understand export, env, and printenv commands.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Environment variables", "PATH variable", "HOME, USER, SHELL", "export command", "env and printenv", "Setting environment variables"],
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

<body class="tutorial-body no-preview" data-lesson="variables-environment">
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
                    <span>Environment Variables</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Environment Variables</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~15 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Environment variables are special variables that are available to all processes started from your shell. They're inherited by child processes and are essential for system configuration and inter-process communication. Understanding environment variables is crucial for system administration, configuring tools, and writing scripts that work across different systems.</p>

                    <!-- Section 1: What are Environment Variables -->
                    <h2>What are Environment Variables?</h2>
                    <p>Environment variables are variables that are exported from your current shell to all child processes. They're different from regular variables because they're inherited by any program or script you run.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/variables-environment.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-environment" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Key Difference:</strong><br>
                        - <strong>Regular Variable:</strong> Only available in current shell<br>
                        - <strong>Environment Variable:</strong> Available to current shell AND all child processes<br>
                        Use <code>export</code> to make a variable an environment variable!
                    </div>

                    <!-- Section 2: Common Environment Variables -->
                    <h2>Common Environment Variables</h2>
                    <p>Every Unix-like system has several standard environment variables that provide information about the system and user environment.</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Variable</th>
                                <th>Description</th>
                                <th>Example Value</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>HOME</code></td>
                                <td>User's home directory</td>
                                <td><code>/home/username</code> or <code>/Users/username</code></td>
                            </tr>
                            <tr>
                                <td><code>USER</code> / <code>USERNAME</code></td>
                                <td>Current username</td>
                                <td><code>alice</code></td>
                            </tr>
                            <tr>
                                <td><code>PATH</code></td>
                                <td>Colon-separated list of directories to search for executables</td>
                                <td><code>/usr/bin:/bin:/usr/local/bin</code></td>
                            </tr>
                            <tr>
                                <td><code>SHELL</code></td>
                                <td>Path to current shell</td>
                                <td><code>/bin/bash</code></td>
                            </tr>
                            <tr>
                                <td><code>PWD</code></td>
                                <td>Current working directory</td>
                                <td><code>/home/user/projects</code></td>
                            </tr>
                            <tr>
                                <td><code>LANG</code> / <code>LC_ALL</code></td>
                                <td>Language/locale settings</td>
                                <td><code>en_US.UTF-8</code></td>
                            </tr>
                            <tr>
                                <td><code>EDITOR</code></td>
                                <td>Default text editor</td>
                                <td><code>vim</code> or <code>nano</code></td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- Section 3: The PATH Variable -->
                    <h2>The PATH Variable</h2>
                    <p>The <code>PATH</code> variable is one of the most important environment variables. It tells the system which directories to search when you type a command. Without PATH, you'd have to type the full path to every command!</p>

                    <pre><code class="language-bash"># View PATH
echo $PATH
# Output: /usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

# PATH is colon-separated
# When you type 'ls', system searches:
# 1. /usr/local/bin/ls
# 2. /usr/bin/ls
# 3. /bin/ls
# 4. (stops at first match)

# Add directory to PATH
export PATH="$PATH:/new/directory"
# Now system will also search /new/directory</code></pre>

                    <div class="warning-box">
                        <strong>Important:</strong> Always append to PATH with <code>PATH="$PATH:/new/path"</code> rather than replacing it! Replacing PATH (<code>PATH="/new/path"</code>) will break most commands because standard directories like <code>/bin</code> and <code>/usr/bin</code> won't be searched anymore.
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 4: Export Command -->
                    <h2>The export Command</h2>
                    <p>To make a variable available to child processes (i.e., make it an environment variable), use the <code>export</code> command. This is essential when you want scripts or commands you run to access your variables.</p>

                    <pre><code class="language-bash"># Regular variable (not exported)
MY_VAR="hello"
bash -c 'echo $MY_VAR'  # Output: (empty - child process can't see it)

# Export the variable
export MY_VAR="hello"
bash -c 'echo $MY_VAR'  # Output: hello (child process can see it)

# Alternative syntax
MY_VAR="hello"
export MY_VAR

# Combined declaration and export
export API_KEY="secret123"
export DEBUG="true"</code></pre>

                    <div class="info-box">
                        <strong>When to Use export:</strong><br>
                        - When running scripts that need the variable<br>
                        - When starting programs that check environment variables<br>
                        - For configuration values (like API keys, paths)<br>
                        - For flags (like DEBUG, VERBOSE)<br>
                        Regular variables are fine for use within a single script.
                    </div>

                    <!-- Section 5: Viewing Environment Variables -->
                    <h2>Viewing Environment Variables</h2>
                    <p>There are several commands to view environment variables, each with slightly different output formats.</p>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Command</th>
                                <th>Description</th>
                                <th>Example</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><code>env</code></td>
                                <td>List all environment variables</td>
                                <td><code>env</code></td>
                            </tr>
                            <tr>
                                <td><code>printenv</code></td>
                                <td>List all environment variables (same as env)</td>
                                <td><code>printenv</code></td>
                            </tr>
                            <tr>
                                <td><code>printenv VAR</code></td>
                                <td>Print specific variable value</td>
                                <td><code>printenv HOME</code></td>
                            </tr>
                            <tr>
                                <td><code>set</code></td>
                                <td>List all variables (including non-exported)</td>
                                <td><code>set | grep MY_VAR</code></td>
                            </tr>
                            <tr>
                                <td><code>echo $VAR</code></td>
                                <td>Print specific variable</td>
                                <td><code>echo $HOME</code></td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- Section 6: Setting Environment Variables -->
                    <h2>Setting Environment Variables</h2>
                    <p>You can set environment variables in several ways, depending on how long you want them to persist.</p>

                    <pre><code class="language-bash"># 1. For current session only (temporary)
export MY_VAR="value"

# 2. For a single command
MY_VAR="value" command_to_run

# 3. In a script (affects script and its children)
#!/bin/bash
export CONFIG_FILE="/path/to/config"
python script.py  # python can see CONFIG_FILE

# 4. Permanently in ~/.bashrc or ~/.bash_profile
# Add to file: export MY_VAR="value"
# Then: source ~/.bashrc</code></pre>

                    <div class="tip-box">
                        <strong>Persistence:</strong><br>
                        - <strong>Temporary:</strong> <code>export VAR="value"</code> in terminal (lost when terminal closes)<br>
                        - <strong>For User:</strong> Add to <code>~/.bashrc</code> (Linux) or <code>~/.bash_profile</code> (macOS)<br>
                        - <strong>System-wide:</strong> Add to <code>/etc/environment</code> or <code>/etc/profile</code> (requires root)
                    </div>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Not exporting variables needed by child processes</h4>
                        <pre><code class="language-bash"># Wrong - child process can't see it
CONFIG_PATH="/etc/config"
python script.py  # script.py can't access CONFIG_PATH

# Correct - export it
export CONFIG_PATH="/etc/config"
python script.py  # script.py can access CONFIG_PATH</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Replacing PATH instead of appending</h4>
                        <pre><code class="language-bash"># Wrong - breaks system commands
export PATH="/new/path"  # Now ls, cd, etc. won't work!

# Correct - append to existing PATH
export PATH="$PATH:/new/path"  # Adds to existing PATH</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Setting environment variables without export</h4>
                        <pre><code class="language-bash"># Wrong - not exported, child can't see it
API_KEY="secret123"
bash script.sh  # script.sh can't access API_KEY

# Correct - export it
export API_KEY="secret123"
bash script.sh  # script.sh can access API_KEY</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Work with Environment Variables</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a script that demonstrates environment variable usage!</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Display common environment variables (HOME, USER, PATH)</li>
                            <li>Create and export a custom environment variable</li>
                            <li>Show the difference between exported and non-exported variables</li>
                            <li>Count how many environment variables are set</li>
                            <li>Display the PATH variable, showing first 3 directories</li>
                        </ul>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-bash">#!/bin/bash
# Environment variables exercise

echo "Common environment variables:"
echo "  HOME: $HOME"
echo "  USER: $USER"
echo "  SHELL: $SHELL"
echo ""

# Create and export variable
export MY_CUSTOM_VAR="Hello from environment"
echo "Exported variable:"
echo "  MY_CUSTOM_VAR: $MY_CUSTOM_VAR"
echo ""

# Count environment variables
env_count=$(env | wc -l)
echo "Total environment variables: $env_count"
echo ""

# Display PATH
echo "PATH variable (first 3 directories):"
echo "$PATH" | tr ':' '\n' | head -3 | nl</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Environment Variables:</strong> Available to current shell and all child processes</li>
                            <li><strong>export:</strong> Use <code>export VAR="value"</code> to make variables available to child processes</li>
                            <li><strong>PATH:</strong> Colon-separated directories where system searches for commands</li>
                            <li><strong>Common Vars:</strong> HOME, USER, SHELL, PWD, PATH, LANG</li>
                            <li><strong>Viewing:</strong> Use <code>env</code>, <code>printenv</code>, or <code>echo $VAR</code></li>
                            <li><strong>PATH Safety:</strong> Always append with <code>PATH="$PATH:/new/path"</code> never replace</li>
                            <li><strong>Persistence:</strong> Add to <code>~/.bashrc</code> or <code>~/.bash_profile</code> for permanent settings</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Perfect! You now understand environment variables. Next, we'll explore <strong>Special Variables</strong> - variables that Bash automatically sets, like <code>$0</code> (script name), <code>$1-$9</code> (arguments), <code>$#</code> (argument count), <code>$@</code> (all arguments), and more. These are essential for writing scripts that accept command-line arguments!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="variables-expansion.jsp" />
                    <jsp:param name="prevTitle" value="Variable Expansion" />
                    <jsp:param name="nextLink" value="variables-special.jsp" />
                    <jsp:param name="nextTitle" value="Special Variables" />
                    <jsp:param name="currentLessonId" value="variables-environment" />
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

