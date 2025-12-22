<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "string-basics" ); request.setAttribute("currentModule", "Arrays & Strings"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>String Manipulation - DSA Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master string manipulation with common patterns: palindromes, anagrams, frequency counting, and substring problems.">
            <meta name="keywords" content="strings, string manipulation, palindrome, anagram, substring, DSA">

            <meta property="og:type" content="article">
            <meta property="og:title" content="String Manipulation - DSA Tutorial">
            <meta property="og:description" content="Learn essential string patterns for coding interviews.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/dsa/string-basics.jsp">
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
        "name": "String Manipulation",
        "description": "Learn essential string manipulation techniques and patterns for interviews.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner to Intermediate",
        "teaches": ["String Manipulation", "Palindromes", "Anagrams", "String Patterns"],
        "timeRequired": "PT12M",
        "isPartOf": {
            "@type": "Course",
            "name": "Data Structures and Algorithms Tutorial",
            "url": "https://8gwifi.org/tutorials/dsa/"
        }
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="string-basics">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>

                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-dsa.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/dsa/">DSA</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>String Manipulation</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">🔤 String Manipulation</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner to Intermediate</span>
                                        <span>~12 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">You're validating user input - checking if a phrase is a palindrome,
                                        ignoring spaces and punctuation. String problems are everywhere in interviews.
                                        Let's master the essential patterns.</p>

                                    <!-- Section 1: String Basics -->
                                    <h2>String Fundamentals</h2>

                                    <p>Strings are <strong>immutable</strong> in most languages - you can't change them
                                        in place. This affects how you solve problems.</p>

                                    <div class="info-box">
                                        <h4>Immutability</h4>
                                        <pre><code class="language-python">s = "hello"
s[0] = 'H'  # Error! Can't modify

# Create new string instead
s = 'H' + s[1:]  # "Hello"</code></pre>
                                        <p><strong>Impact:</strong> String concatenation in loops is O(n²) because each
                                            concatenation creates a new string!</p>
                                        <p><strong>Solution:</strong> Use a list/array and join at the end.</p>
                                    </div>

                                    <!-- Code Example -->
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/string-basics.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-string-basics" />
                                    </jsp:include>

                                    <!-- Quick Quiz -->
                                    <h3>Quick Quiz</h3>
                                    <ul>
                                        <li>
                                            <strong>Why is string concatenation in a loop slow?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                Because strings are immutable, each concatenation creates a new string
                                                and copies all characters. For n concatenations, that's 1+2+3+...+n =
                                                O(n²) operations!
                                            </details>
                                        </li>
                                        <li>
                                            <strong>How do you efficiently build a string?</strong>
                                            <details>
                                                <summary>Show answer</summary>
                                                Use a list to collect parts, then join once at the end:
                                                <code>''.join(parts)</code> - this is O(n) instead of O(n²).
                                            </details>
                                        </li>
                                    </ul>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Common Patterns -->
                                    <h2>Five Essential Patterns</h2>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="dsa/string-patterns.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-patterns" />
                                    </jsp:include>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Pattern</th>
                                                <th>Technique</th>
                                                <th>Complexity</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Two Pointers</strong></td>
                                                <td>Work from both ends</td>
                                                <td>O(n)</td>
                                                <td>Palindrome, reverse</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Hash Map</strong></td>
                                                <td>Count frequencies</td>
                                                <td>O(n)</td>
                                                <td>Anagrams, unique chars</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Sliding Window</strong></td>
                                                <td>Variable substring</td>
                                                <td>O(n)</td>
                                                <td>Longest substring</td>
                                            </tr>
                                            <tr>
                                                <td><strong>String Building</strong></td>
                                                <td>List + join</td>
                                                <td>O(n)</td>
                                                <td>Compression, reversal</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Pattern Matching</strong></td>
                                                <td>Substring search</td>
                                                <td>O(n×m)</td>
                                                <td>Find substring</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- When to Use -->
                                    <h2>Pattern Selection Guide</h2>

                                    <div class="success-box">
                                        <h4>Choose Your Pattern</h4>
                                        <ul>
                                            <li><strong>Palindrome/Reverse:</strong> Two pointers</li>
                                            <li><strong>Anagram/Frequency:</strong> Hash map</li>
                                            <li><strong>Longest/Shortest substring:</strong> Sliding window</li>
                                            <li><strong>Build/Modify string:</strong> List + join</li>
                                            <li><strong>Find pattern:</strong> Built-in search or KMP (advanced)</li>
                                        </ul>
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>❌ String Concatenation in Loop</h4>
                                        <pre><code class="language-python"># Slow: O(n²)
result = ""
for char in s:
    result += char  # Creates new string each time!

# Fast: O(n)
result = ''.join(s)</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Forgetting to Handle Empty Strings</h4>
                                        <pre><code class="language-python">def first_char(s):
    return s[0]  # Error if s is empty!

# Better
def first_char(s):
    return s[0] if s else None</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>❌ Case Sensitivity Issues</h4>
                                        <pre><code class="language-python"># "Hello" != "hello"
# Always normalize case first
s1.lower() == s2.lower()</code></pre>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <h3>The 3-Point String Guide</h3>
                                        <ol>
                                            <li><strong>Immutability:</strong> Strings can't be modified - use list +
                                                join for building</li>
                                            <li><strong>Patterns:</strong> Two pointers, hash map, sliding window - same
                                                as arrays!</li>
                                            <li><strong>Efficiency:</strong> Avoid concatenation in loops - it's O(n²)
                                            </li>
                                        </ol>
                                        <p style="margin-top: 1rem;"><strong>Interview tip:</strong> Most string
                                            problems use the same patterns as array problems. Think: "How would I solve
                                            this with an array?"</p>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>🎉 <strong>Congratulations!</strong> You've completed <strong>Module 2: Arrays &
                                            Strings</strong>!</p>

                                    <div class="success-box">
                                        <h4>You Now Know:</h4>
                                        <ul>
                                            <li>✅ Array fundamentals and O(1) access</li>
                                            <li>✅ Two pointers technique</li>
                                            <li>✅ Sliding window pattern</li>
                                            <li>✅ String manipulation</li>
                                        </ul>
                                        <p style="margin-top: 1rem;"><strong>These patterns solve 50%+ of interview
                                                array/string problems!</strong></p>
                                    </div>

                                    <p>Next up: <strong>Module 3: Linked Lists</strong> - learn pointer-based data
                                        structures and solve problems like reversing lists, detecting cycles, and more!
                                    </p>

                                    <div class="tip-box">
                                        <strong>Practice:</strong> Try "Valid Anagram", "Longest Substring Without
                                        Repeating Characters", and "String Compression" on LeetCode!
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="sliding-window.jsp" />
                                    <jsp:param name="prevTitle" value="Sliding Window" />
                                    <jsp:param name="nextLink" value="bubble-sort.jsp" />
                                    <jsp:param name="nextTitle" value="Bubble Sort" />
                                    <jsp:param name="currentLessonId" value="string-basics" />
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