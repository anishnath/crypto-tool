<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setAttribute("currentLesson", "modules-regex");
   request.setAttribute("currentModule", "Modules & Packages"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Python RegEx - Regular Expressions, Pattern Matching, Search, Replace | 8gwifi.org</title>
    <meta name="description"
        content="Master Python regular expressions with the re module - search, findall, split, sub, pattern syntax, character classes, groups, and practical validation examples.">
    <meta name="keywords"
        content="python regex, python re module, python regular expression, python regex search, python findall, python regex replace, python pattern matching, python regex groups">

    <meta property="og:type" content="article">
    <meta property="og:title" content="Python RegEx - Regular Expressions, Pattern Matching, Search, Replace">
    <meta property="og:description" content="Master Python regular expressions: searching, matching, and replacing text patterns.">
    <meta property="og:site_name" content="8gwifi.org Tutorials">

    <link rel="canonical" href="https://8gwifi.org/tutorials/python/modules-regex.jsp">
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
        "name": "Python Regular Expressions",
        "description": "Master Python regular expressions with the re module - search, findall, split, sub, pattern syntax, and practical examples.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Intermediate",
        "teaches": ["re module functions", "Pattern syntax", "Character classes", "Quantifiers", "Groups and capturing", "Named groups", "Practical validation patterns"],
        "timeRequired": "PT30M",
        "isPartOf": {
            "@type": "Course",
            "name": "Python Tutorial",
            "url": "https://8gwifi.org/tutorials/python/"
        }
    }
    </script>

    <%@ include file="../tutorial-ads.jsp" %>
    <%@ include file="../tutorial-analytics.jsp" %>
</head>

<body class="tutorial-body no-preview" data-lesson="modules-regex">
    <div class="tutorial-layout">
        <%@ include file="../tutorial-header.jsp" %>

        <main class="tutorial-main">
            <%@ include file="../tutorial-sidebar-python.jsp" %>
            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

            <article class="tutorial-content">
                <nav class="breadcrumb">
                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                    <span class="breadcrumb-separator">/</span>
                    <a href="<%=request.getContextPath()%>/tutorials/python/">Python</a>
                    <span class="breadcrumb-separator">/</span>
                    <span>RegEx</span>
                </nav>

                <header class="lesson-header">
                    <h1 class="lesson-title">Regular Expressions (RegEx)</h1>
                    <div class="lesson-meta">
                        <span>Intermediate</span>
                        <span>~30 min read</span>
                    </div>
                </header>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="top" />
                </jsp:include>

                <div class="lesson-body">
                    <p class="lead">Regular expressions are a powerful language for pattern matching in text. With Python's
                    <code>re</code> module, you can search for patterns, validate input, extract data, and transform text.
                    From validating email addresses to parsing log files - regex is an essential skill for text processing,
                    data cleaning, and form validation. Once you master regex, you'll wonder how you ever lived without it!</p>

                    <!-- Section 1: Basic Functions -->
                    <h2>Basic RegEx Functions</h2>
                    <p>Python's <code>re</code> module provides several functions for pattern matching: <code>search()</code>
                    finds the first match, <code>match()</code> checks only at the start, <code>findall()</code> returns
                    all matches, <code>split()</code> divides text at matches, and <code>sub()</code> replaces matches.
                    These are your bread-and-butter regex operations.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/regex-basics.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-basics" />
                    </jsp:include>

                    <div class="info-box">
                        <strong>Raw Strings (r"..."):</strong> Always use raw strings for regex patterns by prefixing with
                        <code>r</code>. This prevents Python from interpreting backslashes. Without it, <code>"\d"</code>
                        might be misinterpreted, but <code>r"\d"</code> is always safe. Get in the habit of using
                        <code>r"pattern"</code> for all regex.
                    </div>

                    <!-- Section 2: Pattern Syntax -->
                    <h2>Pattern Syntax and Metacharacters</h2>
                    <p>Regex patterns use special characters (metacharacters) to match types of characters and define
                    repetition. <code>\d</code> matches digits, <code>\w</code> matches word characters, <code>+</code>
                    means "one or more", and <code>*</code> means "zero or more". These building blocks combine to
                    create powerful patterns.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/regex-patterns.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-patterns" />
                    </jsp:include>

                    <div class="tip-box">
                        <strong>Essential Metacharacters:</strong><br>
                        <code>\d</code> digit, <code>\D</code> non-digit<br>
                        <code>\w</code> word char [a-zA-Z0-9_], <code>\W</code> non-word<br>
                        <code>\s</code> whitespace, <code>\S</code> non-whitespace<br>
                        <code>.</code> any char (except newline)<br>
                        <code>^</code> start, <code>$</code> end<br>
                        <code>\b</code> word boundary
                    </div>

                    <jsp:include page="../tutorial-ad-slot.jsp">
                        <jsp:param name="slot" value="middle" />
                    </jsp:include>

                    <!-- Section 3: Groups -->
                    <h2>Groups and Capturing</h2>
                    <p>Parentheses create groups that capture matched text. You can extract parts of a match, use
                    named groups for clarity, and reference captured groups in replacements. Groups are essential
                    for extracting structured data from text - like pulling apart names, dates, or URLs.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/regex-groups.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-groups" />
                    </jsp:include>

                    <div class="warning-box">
                        <strong>Greedy vs Non-Greedy:</strong> By default, quantifiers like <code>*</code> and <code>+</code>
                        are greedy - they match as much as possible. Add <code>?</code> to make them non-greedy (match
                        minimum). For example, <code>.*</code> in <code>&lt;b&gt;.*&lt;/b&gt;</code> would match too much
                        if you have multiple tags. Use <code>.*?</code> for non-greedy matching.
                    </div>

                    <!-- Section 4: Practical Examples -->
                    <h2>Practical Validation Examples</h2>
                    <p>Regex shines for validation tasks: checking email formats, extracting phone numbers, validating
                    passwords, cleaning messy text, and parsing structured data. These real-world patterns demonstrate
                    how regex solves common programming challenges.</p>

                    <jsp:include page="../tutorial-compiler.jsp">
                        <jsp:param name="codeFile" value="python/regex-practical.py" />
                        <jsp:param name="language" value="python" />
                        <jsp:param name="editorId" value="compiler-practical" />
                    </jsp:include>

                    <!-- Common Mistakes -->
                    <h2>Common Mistakes</h2>

                    <div class="mistake-box">
                        <h4>1. Forgetting raw strings</h4>
                        <pre><code class="language-python">import re

# Wrong - backslash gets interpreted by Python
pattern = "\d+"  # Python sees this differently!

# Correct - use raw string
pattern = r"\d+"

# Even worse with \b (word boundary)
re.findall("\bword\b", text)  # \b is backspace in Python!
re.findall(r"\bword\b", text)  # Correct!</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>2. Confusing search() and match()</h4>
                        <pre><code class="language-python">import re

text = "hello world"

# match() only checks the START of string
re.match(r"world", text)  # None - "world" not at start!

# search() finds anywhere in string
re.search(r"world", text)  # Match found!

# To match entire string, use anchors
re.match(r".*world$", text)  # Works
re.fullmatch(r"hello world", text)  # Better!</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>3. Greedy matching grabs too much</h4>
                        <pre><code class="language-python">import re

html = "<b>bold</b> and <b>more</b>"

# Wrong - greedy .* matches everything between first < and last >
re.findall(r"<b>.*</b>", html)
# Returns: ['<b>bold</b> and <b>more</b>']

# Correct - non-greedy .*? matches minimum
re.findall(r"<b>.*?</b>", html)
# Returns: ['<b>bold</b>', '<b>more</b>']</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>4. Not escaping special characters</h4>
                        <pre><code class="language-python">import re

# Wrong - . matches ANY character
re.findall(r"3.14", "3.14 and 3x14")
# Returns: ['3.14', '3x14']

# Correct - escape the dot to match literal .
re.findall(r"3\.14", "3.14 and 3x14")
# Returns: ['3.14']

# Other chars to escape: . * + ? ^ $ [ ] { } | ( ) \
# Use re.escape() for user input
user_input = "price: $5.00"
pattern = re.escape(user_input)  # "price:\\ \\$5\\.00"</code></pre>
                    </div>

                    <div class="mistake-box">
                        <h4>5. Capturing when you don't need to</h4>
                        <pre><code class="language-python">import re

# With capturing group - returns tuples
re.findall(r"(cat|dog)s?", "cats and dogs")
# Returns: ['cat', 'dog']  # Just the group content!

# Without capturing (non-capturing group)
re.findall(r"(?:cat|dog)s?", "cats and dogs")
# Returns: ['cats', 'dogs']  # Full matches!

# Use (?:...) when you need grouping but not capturing</code></pre>
                    </div>

                    <!-- Exercise -->
                    <h2>Exercise: Log Parser</h2>
                    <div class="exercise-section">
                        <p><strong>Task:</strong> Parse log entries to extract timestamp, level, and message.</p>

                        <p><strong>Requirements:</strong></p>
                        <ul>
                            <li>Parse log format: "[TIMESTAMP] LEVEL: message"</li>
                            <li>Extract the timestamp (in brackets)</li>
                            <li>Extract the log level (INFO, ERROR, WARNING)</li>
                            <li>Extract the message after the colon</li>
                        </ul>

                        <jsp:include page="../tutorial-compiler.jsp">
                            <jsp:param name="codeFile" value="python/exercises/ex-modules-regex.py" />
                            <jsp:param name="language" value="python" />
                            <jsp:param name="editorId" value="exercise-regex" />
                        </jsp:include>

                        <details class="exercise-hint">
                            <summary>Show Solution</summary>
                            <pre><code class="language-python">import re

def parse_log(log_line):
    """Parse a log line and return components."""
    pattern = r"\[(.+?)\]\s+(INFO|ERROR|WARNING):\s+(.+)"
    match = re.match(pattern, log_line)
    if match:
        return {
            "timestamp": match.group(1),
            "level": match.group(2),
            "message": match.group(3)
        }
    return None

# Test logs
logs = [
    "[2024-03-15 10:30:45] INFO: Server started successfully",
    "[2024-03-15 10:31:02] ERROR: Connection refused",
    "[2024-03-15 10:32:15] WARNING: High memory usage detected"
]

for log in logs:
    result = parse_log(log)
    if result:
        print(f"Time: {result['timestamp']}")
        print(f"Level: {result['level']}")
        print(f"Message: {result['message']}")
        print()</code></pre>
                        </details>
                    </div>

                    <!-- Summary -->
                    <h2>Summary</h2>
                    <div class="summary-box">
                        <ul>
                            <li><strong>Functions:</strong> <code>search()</code>, <code>match()</code>, <code>findall()</code>, <code>split()</code>, <code>sub()</code></li>
                            <li><strong>Always use:</strong> Raw strings <code>r"pattern"</code> for regex patterns</li>
                            <li><strong>Character classes:</strong> <code>\d</code> (digit), <code>\w</code> (word), <code>\s</code> (space), <code>.</code> (any)</li>
                            <li><strong>Quantifiers:</strong> <code>*</code> (0+), <code>+</code> (1+), <code>?</code> (0 or 1), <code>{n,m}</code> (range)</li>
                            <li><strong>Anchors:</strong> <code>^</code> (start), <code>$</code> (end), <code>\b</code> (word boundary)</li>
                            <li><strong>Groups:</strong> <code>(...)</code> capture, <code>(?:...)</code> non-capture, <code>(?P&lt;name&gt;...)</code> named</li>
                            <li><strong>Non-greedy:</strong> Add <code>?</code> after quantifier: <code>.*?</code>, <code>+?</code></li>
                            <li><strong>Escape:</strong> <code>re.escape()</code> for user input with special chars</li>
                        </ul>
                    </div>

                    <h2>What's Next?</h2>
                    <p>Congratulations on completing the Modules & Packages module! You now know how to work with dates,
                    math, JSON, and regular expressions. Next, let's learn about <strong>PIP</strong> - Python's package
                    manager that lets you install thousands of third-party packages to extend Python's capabilities!</p>
                </div>

                <jsp:include page="../tutorial-ad-slot.jsp">
                    <jsp:param name="slot" value="bottom" />
                </jsp:include>

                <jsp:include page="../tutorial-nav.jsp">
                    <jsp:param name="prevLink" value="modules-json.jsp" />
                    <jsp:param name="prevTitle" value="JSON" />
                    <jsp:param name="nextLink" value="modules-pip.jsp" />
                    <jsp:param name="nextTitle" value="PIP" />
                    <jsp:param name="currentLessonId" value="modules-regex" />
                </jsp:include>
            </article>
        </main>

        <%@ include file="../tutorial-footer.jsp" %>
    </div>

    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
    <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
</body>

</html>
