<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "loops-for");
   request.setAttribute("currentModule", "Control Flow"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Bash For Loops - Iteration, Arrays, C-Style Loops | 8gwifi.org</title>
    <meta name="description"
        content="Learn Bash for loops: for-in loops, C-style for loops, iterating arrays, ranges, and command output. Master iteration in shell scripts.">
    <meta name="keywords"
        content="bash for loop, bash iteration, bash array loop, bash c-style loop, bash for in, shell scripting loops">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Bash For Loops - Iteration, Arrays, C-Style Loops">
    <meta property="og:description" content="Master Bash for loops for efficient iteration in your scripts.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/bash/loops-for.jsp">
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
        "name": "Bash For Loops",
        "description": "Learn Bash for loops: for-in loops, C-style for loops, iterating arrays, and processing lists.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["For-in loops", "C-style for loops", "Array iteration", "Range iteration", "Command output iteration"],
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

<body class="tutorial-body no-preview" data-lesson="loops-for">
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
                    <span>For Loops</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">For Loops</h1>
                    <div class="lesson-meta">
                        <span>Beginner</span>
                        <span>~25 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">For loops are one of the most powerful and commonly used control structures in Bash. They allow you to iterate over lists, arrays, file sets, command output, and numeric ranges. Mastering for loops is essential for processing multiple items, automating repetitive tasks, and building efficient shell scripts!</p>

                    <!-- Section 1: Basic For-In Loop -->
                    <h2>Basic For-In Loop</h2>
                    <p>The most common type of for loop iterates over a list of items. Each item is assigned to the loop variable and processed.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/loops-for.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-for-basics" />
                    </jsp:include>

                    <pre><code class="language-bash"># Basic syntax
for variable in item1 item2 item3; do
    # code to execute for each item
done

# Example
for fruit in apple banana cherry; do
    echo "Fruit: $fruit"
done

# Output:
# Fruit: apple
# Fruit: banana
# Fruit: cherry</code></pre>

                    <div class="info-box">
                        <strong>Syntax Notes:</strong><br>
                        - <code>for variable in list</code> starts the loop<br>
                        - <code>do</code> begins the loop body<br>
                        - <code>done</code> ends the loop<br>
                        - Loop variable is available as <code>$variable</code> inside the loop
                    </div>

                    <!-- Section 2: Iterating Over Arrays -->
                    <h2>Iterating Over Arrays</h2>
                    <p>For loops are perfect for processing arrays. Use <code>"\${array[@]}"</code> to iterate over all elements.</p>

                    <pre><code class="language-bash"># Array iteration
fruits=("apple" "banana" "cherry")
for fruit in "\${fruits[@]}"; do
    echo "$fruit"
done

# Iterating with index
for i in "\${!fruits[@]}"; do
    echo "Index $i: \${fruits[$i]}"
done</code></pre>

                    <div class="warning-box">
                        <strong>Important:</strong> Always quote array expansion <code>"\${array[@]}"</code> to preserve elements with spaces. Without quotes, elements with spaces will be split into multiple loop iterations.
                    </div>

                    <!-- Section 3: C-Style For Loop -->
                    <h2>C-Style For Loop</h2>
                    <p>Bash supports C-style for loops for numeric iteration. This syntax is useful for counting and numeric ranges.</p>

                    <pre><code class="language-bash"># C-style syntax
for ((initialization; condition; increment)); do
    # code
done

# Example: Count from 1 to 5
for ((i=1; i<=5; i++)); do
    echo "Count: $i"
done

# Example: Count by 2
for ((i=0; i<=10; i+=2)); do
    echo "$i"
done

# Example: Countdown
for ((i=5; i>=1; i--)); do
    echo "Countdown: $i"
done</code></pre>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="bash/loops-for-advanced.sh" />
                        <jsp:param name="language" value="bash" />
                        <jsp:param name="editorId" value="compiler-for-advanced" />
                    </jsp:include>

                    <!-- Section 4: Using Brace Expansion -->
                    <h2>Using Brace Expansion for Ranges</h2>
                    <p>Brace expansion provides an easy way to generate number sequences without using C-style loops.</p>

                    <pre><code class="language-bash"># Number ranges
for num in {1..5}; do
    echo "Number: $num"
done

# With step (Bash 4+)
for num in {0..10..2}; do
    echo "$num"
done

# Character ranges
for letter in {a..e}; do
    echo "$letter"
done

# Reverse ranges
for num in {5..1}; do
    echo "Countdown: $num"
done</code></pre>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 5: Iterating Over Command Output -->
                    <h2>Iterating Over Command Output</h2>
                    <p>For loops can iterate over the output of commands. Each line becomes an iteration.</p>

                    <pre><code class="language-bash"># Iterate over file listing
for file in $(ls /bin); do
    echo "File: $file"
done

# Iterate over lines in a file
for line in $(cat file.txt); do
    echo "Line: $line"
done

# Better: using while read for files (preserves spaces)
while IFS= read -r line; do
    echo "$line"
done < file.txt</code></pre>

                    <div class="tip-box">
                        <strong>Pro Tip:</strong> When iterating over command output with spaces, use <code>while read</code> instead of <code>for</code> to preserve whitespace. Command substitution with <code>$()</code> splits on spaces by default.
                    </div>

                    <!-- Section 6: Special Variables in Loops -->
                    <h2>Iterating Over Script Arguments</h2>
                    <p>For loops can process command-line arguments passed to your script.</p>

                    <pre><code class="language-bash"># Iterate over all arguments
for arg in "$@"; do
    echo "Argument: $arg"
done

# Shorthand: "$@" is default for for loop
for arg; do
    echo "Argument: $arg"
done

# Iterate with index
i=1
for arg in "$@"; do
    echo "Argument $i: $arg"
    ((i++))
done</code></pre>

                    <!-- Section 7: Nested For Loops -->
                    <h2>Nested For Loops</h2>
                    <p>You can nest for loops inside other for loops to create multi-dimensional iterations.</p>

                    <pre><code class="language-bash"># Nested loops
for i in {1..3}; do
    for j in {a..c}; do
        echo "$i$j"
    done
done

# Output:
# 1a, 1b, 1c, 2a, 2b, 2c, 3a, 3b, 3c</code></pre>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Not quoting array expansion</h4>
                        <pre><code class="language-bash"># Wrong - elements with spaces get split
files=("file one.txt" "file two.txt")
for file in \${files[@]}; do
    echo "$file"  # Prints: file, one.txt, file, two.txt
done

# Correct - quote the expansion
for file in "\${files[@]}"; do
    echo "$file"  # Prints: file one.txt, file two.txt
done</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Using $variable instead of just variable in C-style loop</h4>
                        <pre><code class="language-bash"># Wrong - $ not needed in (( ))
for (($i=1; $i<=5; $i++)); do  # Syntax error!
    echo "$i"
done

# Correct - no $ in arithmetic context
for ((i=1; i<=5; i++)); do
    echo "$i"
done</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Using for to read files line by line</h4>
                        <pre><code class="language-bash"># Wrong - splits on spaces, not lines
for line in $(cat file.txt); do
    echo "$line"
done

# Correct - use while read
while IFS= read -r line; do
    echo "$line"
done < file.txt</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Process Multiple Files</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Create a script that processes multiple items using for loops!</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Use a for-in loop to iterate over a list of items</li>
                            <li>Use a C-style for loop to count from 1 to 10</li>
                            <li>Iterate over an array and process each element</li>
                            <li>Use brace expansion to generate a range</li>
                            <li>Create a nested loop (optional: multiplication table)</li>
                        </ul>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-bash">#!/bin/bash
# For loop exercises

# 1. For-in loop
echo "Fruits:"
for fruit in apple banana cherry; do
    echo "  - $fruit"
done

# 2. C-style loop
echo -e "\nCounting 1-10:"
for ((i=1; i<=10; i++)); do
    echo "  $i"
done

# 3. Array iteration
echo -e "\nColors:"
colors=("red" "green" "blue")
for color in "\${colors[@]}"; do
    echo "  $color"
done

# 4. Brace expansion
echo -e "\nNumbers 1-5:"
for num in {1..5}; do
    echo "  $num"
done

# 5. Nested loop (multiplication table)
echo -e "\nMultiplication table (2x):"
for i in {1..5}; do
    for j in {1..3}; do
        result=$((i * j))
        echo -n "  $i×$j=$result"
    done
    echo ""
done</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>For-In:</strong> <code>for var in list; do ... done</code> iterates over items</li>
                            <li><strong>C-Style:</strong> <code>for ((i=1; i<=5; i++)); do ... done</code> for numeric loops</li>
                            <li><strong>Arrays:</strong> Use <code>"\${array[@]}"</code> (quoted) to preserve spaces</li>
                            <li><strong>Ranges:</strong> Use <code>{1..5}</code> or C-style for numeric sequences</li>
                            <li><strong>Arguments:</strong> Use <code>"$@"</code> to iterate over script arguments</li>
                            <li><strong>Command Output:</strong> Use <code>$(command)</code> but beware of space splitting</li>
                            <li><strong>Files:</strong> Use <code>while read</code> instead of <code>for</code> for line-by-line</li>
                            <li><strong>Nested:</strong> For loops can be nested for multi-dimensional iteration</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Perfect! You've mastered for loops for iteration. Next, we'll learn about <strong>While & Until Loops</strong> - control structures that continue looping based on conditions rather than iterating over lists. These are essential for reading files, waiting for conditions, and creating interactive scripts!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="control-case.jsp" />
                    <jsp:param name="prevTitle" value="Case Statements" />
                    <jsp:param name="nextLink" value="loops-while.jsp" />
                    <jsp:param name="nextTitle" value="While & Until Loops" />
                    <jsp:param name="currentLessonId" value="loops-for" />
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

