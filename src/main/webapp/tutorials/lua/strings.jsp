<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "strings" );
        request.setAttribute("currentModule", "Operators & Control Flow" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Strings in Lua - Lua Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Lua strings: creation, concatenation, manipulation, and pattern matching. Learn the string library functions and best practices for working with text.">
            <meta name="keywords"
                content="lua strings, string manipulation, string library, pattern matching, lua string functions, string concatenation">

            <!-- Open Graph -->
            <meta property="og:type" content="article">
            <meta property="og:title" content="Strings in Lua - Lua Tutorial">
            <meta property="og:description"
                content="Learn Lua string manipulation, pattern matching, and the powerful string library.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/lua/strings.jsp">
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
        "name": "Strings in Lua",
        "description": "Master Lua strings: creation, concatenation, manipulation, and pattern matching with the string library.",
        "learningResourceType": "Tutorial",
        "url": "https://8gwifi.org/tutorials/lua/strings.jsp",
        "keywords": "lua strings, string manipulation, pattern matching, string library",
        "educationalLevel": "Beginner",
        "interactivityType": "active",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "teaches": ["String creation", "String concatenation", "String library", "Pattern matching"],
        "timeRequired": "PT25M",
        "isPartOf": {
            "@type": "Course",
            "name": "Lua Tutorial",
            "url": "https://8gwifi.org/tutorials/lua/"
        }
    }
    </script>

            <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "BreadcrumbList",
        "itemListElement": [
            {
                "@type": "ListItem",
                "position": 1,
                "name": "Tutorials",
                "item": "https://8gwifi.org/tutorials/"
            },
            {
                "@type": "ListItem",
                "position": 2,
                "name": "Lua",
                "item": "https://8gwifi.org/tutorials/lua/"
            },
            {
                "@type": "ListItem",
                "position": 3,
                "name": "Strings"
            }
        ]
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body" data-lesson="strings">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>

                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-lua.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/lua/">Lua</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Strings</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Strings in Lua</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~25 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Strings are sequences of characters used to represent text. Lua
                                        provides
                                        powerful string manipulation capabilities through its built-in string library.
                                        Whether
                                        you're processing user input, formatting output, or parsing data, understanding
                                        strings
                                        is essential. Let's explore everything you need to know about working with
                                        strings in
                                        Lua!</p>

                                    <!-- String Basics -->
                                    <h2>Creating Strings</h2>
                                    <p>Lua offers several ways to create strings:</p>

                                    <h3>1. Double Quotes</h3>
                                    <pre><code class="language-lua">local message = "Hello, World!"
local name = "Alice"</code></pre>

                                    <h3>2. Single Quotes</h3>
                                    <pre><code class="language-lua">local greeting = 'Hello, Lua!'
local text = 'It\'s a beautiful day'  -- Escape single quote</code></pre>

                                    <h3>3. Long Strings (Multi-line)</h3>
                                    <pre><code class="language-lua">local multiline = [[
This is a
multi-line
string
]]

local code = [[
function hello()
    print("Hello!")
end
]]</code></pre>

                                    <div class="tip-box">
                                        <strong>Tip:</strong> Use long strings <code>[[...]]</code> for multi-line text
                                        or when
                                        you need to include quotes without escaping. They're perfect for embedding code
                                        or SQL
                                        queries!
                                    </div>

                                    <!-- String Operations -->
                                    <h2>String Operations</h2>

                                    <h3>Concatenation</h3>
                                    <p>Use <code>..</code> to join strings together:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/strings-basics.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-basics" />
                                    </jsp:include>

                                    <h3>String Length</h3>
                                    <p>Use the <code>#</code> operator to get string length:</p>

                                    <pre><code class="language-lua">local text = "Hello"
print(#text)  -- 5

local empty = ""
print(#empty)  -- 0</code></pre>

                                    <div class="warning-box">
                                        <strong>Important:</strong> Strings in Lua are immutable. When you concatenate
                                        or
                                        modify a string, Lua creates a new string. The original string remains
                                        unchanged.
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- String Library -->
                                    <h2>String Library Functions</h2>
                                    <p>Lua's string library provides powerful functions for string manipulation:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Function</th>
                                                <th>Description</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>string.upper(s)</code></td>
                                                <td>Convert to uppercase</td>
                                                <td><code>string.upper("hello")</code> → "HELLO"</td>
                                            </tr>
                                            <tr>
                                                <td><code>string.lower(s)</code></td>
                                                <td>Convert to lowercase</td>
                                                <td><code>string.lower("HELLO")</code> → "hello"</td>
                                            </tr>
                                            <tr>
                                                <td><code>string.reverse(s)</code></td>
                                                <td>Reverse string</td>
                                                <td><code>string.reverse("abc")</code> → "cba"</td>
                                            </tr>
                                            <tr>
                                                <td><code>string.len(s)</code></td>
                                                <td>Get length</td>
                                                <td><code>string.len("hello")</code> → 5</td>
                                            </tr>
                                            <tr>
                                                <td><code>string.sub(s, i, j)</code></td>
                                                <td>Extract substring</td>
                                                <td><code>string.sub("hello", 1, 3)</code> → "hel"</td>
                                            </tr>
                                            <tr>
                                                <td><code>string.rep(s, n)</code></td>
                                                <td>Repeat string n times</td>
                                                <td><code>string.rep("*", 5)</code> → "*****"</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h3>Try String Functions</h3>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/strings-library.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-library" />
                                    </jsp:include>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> You can use method syntax for string functions:
                                        <code>str:upper()</code> instead of <code>string.upper(str)</code>. Both work
                                        the
                                        same!
                                    </div>

                                    <!-- String Formatting -->
                                    <h2>String Formatting</h2>
                                    <p>Use <code>string.format()</code> for formatted output (like C's printf):</p>

                                    <pre><code class="language-lua">-- Format numbers
local price = 19.99
print(string.format("Price: $%.2f", price))  -- Price: $19.99

-- Format strings
local name = "Alice"
local age = 25
print(string.format("Name: %s, Age: %d", name, age))

-- Padding and alignment
print(string.format("%10s", "hello"))     -- Right-aligned
print(string.format("%-10s", "hello"))    -- Left-aligned
print(string.format("%05d", 42))          -- 00042</code></pre>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Format</th>
                                                <th>Type</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>%s</code></td>
                                                <td>String</td>
                                                <td><code>string.format("%s", "hello")</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>%d</code></td>
                                                <td>Integer</td>
                                                <td><code>string.format("%d", 42)</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>%f</code></td>
                                                <td>Float</td>
                                                <td><code>string.format("%.2f", 3.14159)</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>%x</code></td>
                                                <td>Hexadecimal</td>
                                                <td><code>string.format("%x", 255)</code> → "ff"</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Pattern Matching -->
                                    <h2>Pattern Matching</h2>
                                    <p>Lua uses patterns (similar to regular expressions) for searching and replacing:
                                    </p>

                                    <h3>Common Pattern Functions</h3>
                                    <ul>
                                        <li><code>string.find(s, pattern)</code> - Find pattern in string</li>
                                        <li><code>string.match(s, pattern)</code> - Extract matching part</li>
                                        <li><code>string.gmatch(s, pattern)</code> - Iterate over matches</li>
                                        <li><code>string.gsub(s, pattern, replacement)</code> - Replace pattern</li>
                                    </ul>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/strings-patterns.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-patterns" />
                                    </jsp:include>

                                    <h3>Pattern Classes</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Pattern</th>
                                                <th>Matches</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>%a</code></td>
                                                <td>Letters (a-z, A-Z)</td>
                                            </tr>
                                            <tr>
                                                <td><code>%d</code></td>
                                                <td>Digits (0-9)</td>
                                            </tr>
                                            <tr>
                                                <td><code>%w</code></td>
                                                <td>Alphanumeric (letters and digits)</td>
                                            </tr>
                                            <tr>
                                                <td><code>%s</code></td>
                                                <td>Whitespace</td>
                                            </tr>
                                            <tr>
                                                <td><code>.</code></td>
                                                <td>Any character</td>
                                            </tr>
                                            <tr>
                                                <td><code>+</code></td>
                                                <td>One or more</td>
                                            </tr>
                                            <tr>
                                                <td><code>*</code></td>
                                                <td>Zero or more</td>
                                            </tr>
                                            <tr>
                                                <td><code>-</code></td>
                                                <td>Zero or more (non-greedy)</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="tip-box">
                                        <strong>Tip:</strong> Lua patterns are NOT regular expressions! They're simpler
                                        but
                                        still very powerful. Use <code>%</code> to escape special characters.
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Practice Exercise</h2>
                                    <p>Try these string manipulation challenges:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/exercises/ex-strings.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-exercise" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <p>In this lesson, you learned:</p>
                                        <ul>
                                            <li>Creating strings with quotes and long strings <code>[[...]]</code></li>
                                            <li>String concatenation with <code>..</code></li>
                                            <li>String library functions: <code>upper</code>, <code>lower</code>,
                                                <code>sub</code>, <code>find</code>, etc.
                                            </li>
                                            <li>String formatting with <code>string.format()</code></li>
                                            <li>Pattern matching for searching and replacing</li>
                                            <li>Common pattern classes: <code>%a</code>, <code>%d</code>,
                                                <code>%w</code>,
                                                <code>%s</code>
                                            </li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Now that you can work with strings, it's time to learn about <strong>control
                                            flow</strong>. In the next lesson, we'll explore conditional statements
                                        (<code>if</code>, <code>elseif</code>, <code>else</code>) to make decisions in
                                        your
                                        code. Let's continue! 🚀</p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="operators.jsp" />
                                    <jsp:param name="prevTitle" value="Operators" />
                                    <jsp:param name="nextLink" value="conditionals.jsp" />
                                    <jsp:param name="nextTitle" value="Conditionals" />
                                    <jsp:param name="currentLessonId" value="strings" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-simple.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/lua.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>