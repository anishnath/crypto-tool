<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "variables-basics");
   request.setAttribute("currentModule", "Variables & Environment"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Bash Variables - Assignment, Naming Rules, Accessing Variables | 8gwifi.org</title>
    <meta name="description"
        content="Learn Bash variables: how to assign values, naming rules, accessing variables with $, and unsetting variables. Master the foundation of Bash scripting.">
    <meta name="keywords"
        content="bash variables, variable assignment, bash variable naming, bash $, unset variable, learn bash variables, bash scripting basics">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Bash Variables - Assignment, Naming Rules, Accessing Variables">
    <meta property="og:description" content="Learn how to work with variables in Bash. Master assignment, naming rules, and accessing variable values.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/variables-basics.jsp">
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
        "name": "Bash Variables",
        "description": "Learn Bash variables: assignment, naming rules, accessing with $, and unsetting variables.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["Variable assignment", "Variable naming rules", "Accessing variables", "Variable reassignment", "Unsetting variables", "Case sensitivity"],
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

<body class="tutorial-body no-preview" data-lesson="variables-basics">
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
                    <span>Variables</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Variables</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~20 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Variables are containers for storing data in Bash. They're fundamental to any programming or scripting language, and Bash is no exception. In this lesson, you'll learn how to create variables, assign values, follow naming conventions, and work with variables effectively. Unlike many languages, Bash doesn't require variable declarations - just assign a value and use it!</p>

                    <!-- Section 1: Variable Assignment -->
                    <h2>Variable Assignment</h2>
                    <p>In Bash, you create a variable simply by assigning a value to it. The syntax is straightforward: <code>variable_name=value</code>. Note that there are <strong>no spaces</strong> around the equals sign!</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/variables-basics.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-variables-basics" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Key Rule:</strong> No spaces around <code>=</code> in variable assignment!<br>
                        - <code>name="Alice"</code> ✓ Correct<br>
                        - <code>name = "Alice"</code> ✗ Wrong (Bash will try to run <code>name</code> as a command)
                    </div>

                    <!-- Section 2: Accessing Variables -->
                    <h2>Accessing Variables</h2>
                    <p>To use a variable's value, prefix it with the dollar sign <code>$</code>. Bash will replace <code>$variable_name</code> with the actual value stored in the variable.</p>

                    <pre><code class="language-bash"># Assign a value
name="Alice"
age=25

# Access the value
echo "My name is $name"
echo "I am $age years old"

# Can also use braces for clarity
echo "Hello, \${name}!"
echo "Age: \${age}"</code></pre>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> Using braces <code>\${variable}</code> is often clearer and required in certain situations. For example, <code>\${name}_file</code> works, but <code>$name_file</code> tries to access a variable called <code>name_file</code>!
                    </div>

                    <!-- Section 3: Variable Naming Rules -->
                    <h2>Variable Naming Rules</h2>
                    <p>Bash has specific rules for variable names. Understanding these rules helps you write valid code and avoid errors.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/variables-naming.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-variables-naming" />
                    </jsp:include>

                    <table class="info-table">
                        <thead>
                            <tr>
                                <th>Rule</th>
                                <th>Valid</th>
                                <th>Invalid</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Can contain letters, numbers, underscores</td>
                                <td><code>var1</code>, <code>my_var</code>, <code>VAR_NAME</code></td>
                                <td><code>2var</code> (can't start with number)</td>
                            </tr>
                            <tr>
                                <td>Case-sensitive</td>
                                <td><code>name</code> and <code>Name</code> are different</td>
                                <td>N/A</td>
                            </tr>
                            <tr>
                                <td>No spaces</td>
                                <td><code>my_var</code></td>
                                <td><code>my var</code> (space not allowed)</td>
                            </tr>
                            <tr>
                                <td>No hyphens</td>
                                <td><code>my_var</code></td>
                                <td><code>my-var</code> (hyphen not allowed)</td>
                            </tr>
                            <tr>
                                <td>Avoid reserved words</td>
                                <td><code>count</code>, <code>total</code></td>
                                <td><code>if</code>, <code>then</code>, <code>else</code> (reserved)</td>
                            </tr>
                        </tbody>
                    </table>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 4: String vs Numbers -->
                    <h2>Strings vs Numbers</h2>
                    <p>Bash treats all variables as strings by default. Even numbers are stored as strings, but Bash can perform arithmetic when needed.</p>

                    <pre><code class="language-bash"># Both are strings
text="Hello"
number="42"

# But Bash can do arithmetic
count=10
count=$((count + 1))  # Arithmetic expansion
echo $count  # 11

# Or use let
let count=count+1
echo $count  # 12</code></pre>

                    <div class="info-box">
                        <strong>Important:</strong> Bash doesn't have separate data types for strings and numbers. Everything is a string, but Bash can interpret strings as numbers for arithmetic operations. We'll cover arithmetic in detail in the Operators module.
                    </div>

                    <!-- Section 5: Unsetting Variables -->
                    <h2>Unsetting Variables</h2>
                    <p>To remove a variable (make it undefined), use the <code>unset</code> command. This is useful for cleaning up or resetting values.</p>

                    <pre><code class="language-bash"># Create a variable
temp="temporary data"
echo $temp  # temporary data

# Unset it
unset temp
echo $temp  # (empty - variable no longer exists)

# Check if variable is set
if [ -z "\${temp:-}" ]; then
    echo "Variable is unset or empty"
fi</code></pre>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Spaces around equals sign</h4>
                        <pre><code class="language-bash"># Wrong - spaces cause error
name = "Alice"  # Error: command not found

# Correct - no spaces
name="Alice"</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Forgetting $ when accessing variables</h4>
                        <pre><code class="language-bash"># Wrong - prints literal "name"
name="Alice"
echo name  # Output: name

# Correct - use $ to access value
echo $name  # Output: Alice</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Using hyphens in variable names</h4>
                        <pre><code class="language-bash"># Wrong - hyphens not allowed
my-var="value"  # Error: command not found

# Correct - use underscore
my_var="value"</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Starting variable name with number</h4>
                        <pre><code class="language-bash"># Wrong - can't start with number
2nd_place="silver"  # Error: command not found

# Correct - start with letter or underscore
second_place="silver"
_2nd_place="silver"  # Also valid</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Not using braces when needed</h4>
                        <pre><code class="language-bash"># Ambiguous - Bash looks for "name_file" variable
name="test"
echo $name_file  # Wrong: tries to find variable "name_file"

# Correct - use braces for clarity
echo \${name}_file  # Output: test_file</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Work with Variables</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a script that uses variables to store and display information about yourself!</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Create variables for: first name, last name, age, city</li>
                            <li>Print a greeting using your full name</li>
                            <li>Print your age and city</li>
                            <li>Use proper variable naming conventions (lowercase with underscores)</li>
                            <li>Unset one variable and show it's no longer available</li>
                        </ul>

                        <p><strong>Hint:</strong> Remember no spaces around <code>=</code>, and use <code>$</code> to access variable values!</p>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-bash">#!/bin/bash
# Personal information script

# Create variables
first_name="Alex"
last_name="Johnson"
age=28
city="San Francisco"

# Display information
echo "Hello! My name is $first_name $last_name"
echo "I am $age years old"
echo "I live in $city"
echo ""

# Unset a variable
unset city
echo "After unsetting city:"
echo "City variable: '\${city:-not set}'"</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Assignment:</strong> <code>variable=value</code> (no spaces around <code>=</code>)</li>
                            <li><strong>Access:</strong> Use <code>$variable</code> or <code>\${variable}</code> to get the value</li>
                            <li><strong>Naming:</strong> Letters, numbers, underscores; case-sensitive; can't start with number</li>
                            <li><strong>All Strings:</strong> Bash treats all variables as strings, but can do arithmetic</li>
                            <li><strong>Unset:</strong> Use <code>unset variable</code> to remove a variable</li>
                            <li><strong>Braces:</strong> Use <code>\${var}</code> when clarity is needed or for concatenation</li>
                            <li><strong>No Declaration:</strong> Variables don't need to be declared - just assign and use</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Great progress! Now that you understand basic variables, let's explore <strong>Variable Expansion</strong> - powerful techniques for working with variables, including default values, error handling, and string manipulation. You'll learn patterns like <code>\${var:-default}</code> that make your scripts more robust!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="terminal-basics.jsp" />
                    <jsp:param name="prevTitle" value="Terminal Basics" />
                    <jsp:param name="nextLink" value="variables-expansion.jsp" />
                    <jsp:param name="nextTitle" value="Variable Expansion" />
                    <jsp:param name="currentLessonId" value="variables-basics" />
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

