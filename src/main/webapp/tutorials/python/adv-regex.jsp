<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "adv-regex" ); request.setAttribute("currentModule", "Advanced Topics" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Python Regular Expressions - re Module, Pattern Matching & Search | 8gwifi.org</title>
            <meta name="description"
                content="Master Python regular expressions with the re module. Learn pattern matching, search, findall, groups, flags, and advanced regex techniques for text processing and validation.">
            <meta name="keywords"
                content="python regex, python re module, python regular expression, pattern matching, text processing, regex groups, python validation">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Python Regular Expressions - re Module, Pattern Matching & Search">
            <meta property="og:description"
                content="Master Python regular expressions with the re module. Learn pattern matching, search, findall, and advanced regex techniques with interactive examples.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/python/adv-regex.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
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
        "description": "Master Python regular expressions with the re module. Learn pattern matching, search, findall, and advanced regex techniques.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Advanced",
        "teaches": ["re module", "Pattern matching", "re.search", "re.findall", "re.match", "Regex groups", "Regex flags", "Compiled regex", "Pattern substitution"],
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

        <body class="tutorial-body no-preview" data-lesson="adv-regex">
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
                                    <span>Advanced</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Regular Expressions</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~30 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Regular expressions (regex) are powerful pattern matching tools that
                                        let you search, extract, and manipulate text using complex patterns. Python's
                                        <code>re</code> module provides functions for working with regex patterns. Master
                                        regex and you can validate input, extract data, find/replace text, and process
                                        structured information efficiently!</p>

                                    <h2>Basic Pattern Matching</h2>
                                    <p>The <code>re</code> module provides several functions for pattern matching. The
                                        most common are <code>re.search()</code> (finds first match), <code>re.findall()</code>
                                        (finds all matches), and <code>re.match()</code> (matches at string start).</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/adv-regex-basics.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-basics" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Key Functions:</strong><br>
                                        - <code>re.search(pattern, string)</code>: Finds first match anywhere in string,
                                        returns Match object or None<br>
                                        - <code>re.match(pattern, string)</code>: Matches only at string start, returns
                                        Match object or None<br>
                                        - <code>re.findall(pattern, string)</code>: Finds all matches, returns list of
                                        strings<br>
                                        - <code>re.finditer(pattern, string)</code>: Finds all matches, returns iterator of
                                        Match objects
                                    </div>

                                    <h2>Common Regex Patterns</h2>
                                    <p>Regex patterns use special characters and sequences to match text. Here are the most
                                        commonly used patterns:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/adv-regex-patterns.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-patterns" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> Use raw strings (<code>r"pattern"</code>) for regex
                                        patterns to avoid escaping backslashes. In raw strings, <code>\d</code> stays as
                                        <code>\d</code> instead of being interpreted as an escape sequence!
                                    </div>

                                    <h2>Groups and Capturing</h2>
                                    <p>Parentheses <code>()</code> create groups that capture parts of the match. You can
                                        access captured groups using the <code>group()</code> method on Match objects, or
                                        use them in substitutions.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/adv-regex-groups.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-groups" />
                                    </jsp:include>

                                    <h2>Substitution with re.sub</h2>
                                    <p>The <code>re.sub()</code> function replaces matches with replacement text. You can
                                        use captured groups in the replacement string using <code>\1</code>, <code>\2</code>,
                                        etc.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/adv-regex-sub.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-sub" />
                                    </jsp:include>

                                    <div class="warning-box">
                                        <strong>Performance Tip:</strong> If you're using the same pattern multiple times,
                                        compile it first with <code>re.compile()</code>. This is faster than calling
                                        <code>re.search()</code> repeatedly with the same pattern!
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Using match() instead of search()</h4>
                                        <pre><code class="language-python"># Wrong - match only works at start
import re

text = "Contact: email@example.com"
result = re.match(r"\S+@\S+", text)  # Returns None!
print(result)  # None - no match at start

# Correct - use search for anywhere in string
result = re.search(r"\S+@\S+", text)  # Finds email
print(result.group())  # 'email@example.com'</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Not using raw strings for patterns</h4>
                                        <pre><code class="language-python"># Wrong - backslashes need escaping
import re

# This tries to match tab character, not word boundary!
pattern = "\bword\b"  # \b is interpreted as backspace character
text = "a word here"
result = re.search(pattern, text)  # Won't work as expected

# Correct - use raw string
pattern = r"\bword\b"  # \b is word boundary
result = re.search(pattern, text)  # Works correctly
print(result.group())  # 'word'</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Forgetting that search/match return Match objects or None</h4>
                                        <pre><code class="language-python"># Wrong - calling .group() on None crashes
import re

text = "No email here"
match = re.search(r"\S+@\S+", text)
email = match.group()  # AttributeError: 'NoneType' has no attribute 'group'

# Correct - check for None first
match = re.search(r"\S+@\S+", text)
if match:
    email = match.group()
    print(email)
else:
    print("No email found")</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>4. Greedy vs non-greedy matching</h4>
                                        <pre><code class="language-python"># Wrong - greedy matching takes too much
import re

text = "<p>First</p> and <p>Second</p>"
# Greedy - matches from first < to last >
match = re.search(r"<p>.*</p>", text)
print(match.group())  # '<p>First</p> and <p>Second</p>' - too much!

# Correct - use non-greedy *?
match = re.search(r"<p>.*?</p>", text)
print(match.group())  # '<p>First</p>' - just first match</code></pre>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Exercise: Extract Phone Numbers</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a function that extracts phone numbers from text.
                                            Handle both formats: (123) 456-7890 and 123-456-7890.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Import the <code>re</code> module</li>
                                            <li>Create a function <code>extract_phones(text)</code> that finds all phone
                                                numbers</li>
                                            <li>Use <code>re.findall()</code> to extract matches</li>
                                            <li>Support formats: (123) 456-7890 and 123-456-7890</li>
                                            <li>Return a list of all found phone numbers</li>
                                            <li>Test with text containing multiple phone numbers</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="python/exercises/ex-adv-regex.py" />
                                            <jsp:param name="language" value="python" />
                                            <jsp:param name="editorId" value="exercise-adv-regex" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-python">import re

def extract_phones(text):
    """Extract phone numbers in formats (123) 456-7890 or 123-456-7890."""
    # Pattern matches: (optional area code in parens) digits-digits-digits
    pattern = r"\(?\d{3}\)?\s?-?\s?\d{3}-\d{4}"
    phones = re.findall(pattern, text)
    return phones


# Test the function
text = """
Contact us at (555) 123-4567 or 555-987-6543.
Our office is at 123-456-7890.
Call (888) 555-0000 for support.
"""

phones = extract_phones(text)
print("Found phone numbers:")
for phone in phones:
    print(f"  - {phone}")</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>re Module:</strong> Python's module for regular expression pattern
                                                matching</li>
                                            <li><strong>re.search():</strong> Finds first match anywhere in string, returns
                                                Match object or None</li>
                                            <li><strong>re.match():</strong> Matches only at string start, returns Match
                                                object or None</li>
                                            <li><strong>re.findall():</strong> Finds all matches, returns list of strings or
                                                tuples (if groups)</li>
                                            <li><strong>re.sub():</strong> Replaces matches with replacement text, supports
                                                group references like <code>\1</code></li>
                                            <li><strong>Raw Strings:</strong> Use <code>r"pattern"</code> to avoid escaping
                                                backslashes</li>
                                            <li><strong>Groups:</strong> Use parentheses <code>()</code> to capture parts of
                                                matches, access with <code>group()</code></li>
                                            <li><strong>Common Patterns:</strong> <code>\d</code> (digit), <code>\w</code>
                                                (word), <code>\s</code> (space), <code>+</code> (1+), <code>*</code> (0+),
                                                <code>?</code> (0 or 1), <code>{n,m}</code> (range)</li>
                                            <li><strong>Compiled Regex:</strong> Use <code>re.compile()</code> for better
                                                performance when reusing patterns</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Regular expressions are powerful tools for text processing! Next, we'll explore
                                        <strong>type hinting</strong>, which allows you to add type annotations to your
                                        Python code. While Python is dynamically typed, type hints improve code
                                        readability, enable better IDE support, and can catch errors with type checkers like
                                        mypy!</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="adv-context.jsp" />
                                    <jsp:param name="prevTitle" value="Context Managers" />
                                    <jsp:param name="nextLink" value="adv-typing.jsp" />
                                    <jsp:param name="nextTitle" value="Type Hinting" />
                                    <jsp:param name="currentLessonId" value="adv-regex" />
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