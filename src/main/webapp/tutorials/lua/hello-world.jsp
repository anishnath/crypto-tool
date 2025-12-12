<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "hello-world" ); request.setAttribute("currentModule", "Getting Started" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Hello World in Lua - Lua Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Write your first Lua program! Learn about print(), comments, and basic Lua syntax with interactive examples. Free Lua tutorial for beginners.">
            <meta name="keywords"
                content="lua hello world, first lua program, lua print, lua comments, learn lua, lua tutorial">

            <!-- Open Graph -->
            <meta property="og:type" content="article">
            <meta property="og:title" content="Hello World in Lua - Lua Tutorial">
            <meta property="og:description" content="Write your first Lua program and learn the basics of Lua syntax.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/lua/hello-world.jsp">
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
        "name": "Hello World in Lua",
        "description": "Write your first Lua program! Learn about print(), comments, and basic Lua syntax with interactive examples.",
        "learningResourceType": "Tutorial",
        "url": "https://8gwifi.org/tutorials/lua/hello-world.jsp",
        "keywords": "lua hello world, first lua program, lua print, lua comments",
        "educationalLevel": "Beginner",
        "interactivityType": "active",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "teaches": ["Lua print function", "Lua comments", "Basic Lua syntax", "First Lua program"],
        "timeRequired": "PT10M",
        "isPartOf": {
            "@type": "Course",
            "name": "Lua Tutorial",
            "description": "Complete Lua programming course from beginner to advanced with interactive examples",
            "url": "https://8gwifi.org/tutorials/lua/",
            "provider": {
                "@type": "Organization",
                "name": "8gwifi.org",
                "url": "https://8gwifi.org"
            }
        },
        "author": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
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
                "name": "Hello World"
            }
        ]
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="hello-world">
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
                                    <span>Hello World</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Hello World</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~10 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">It's time to write your first Lua program! Following the
                                        time-honored tradition
                                        of programming, we'll start with "Hello, World!"—a simple program that displays
                                        text on the screen.
                                        This lesson will introduce you to the <code>print()</code> function, comments,
                                        and the basic
                                        structure of a Lua program.</p>

                                    <!-- Your First Lua Program -->
                                    <h2>Your First Lua Program</h2>
                                    <p>Let's start with the simplest possible Lua program. Click "Run" to execute it:
                                    </p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/hello-world.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-hello" />
                                    </jsp:include>

                                    <p>Congratulations! You just ran your first Lua program! 🎉</p>

                                    <div class="info-box">
                                        <strong>How it works:</strong>
                                        <ul>
                                            <li><code>print()</code> is a built-in function that outputs text to the
                                                console</li>
                                            <li>Text inside quotes (<code>"..."</code>) is called a
                                                <strong>string</strong></li>
                                            <li>Each statement in Lua is executed line by line, from top to bottom</li>
                                        </ul>
                                    </div>

                                    <!-- The print() Function -->
                                    <h2>The print() Function</h2>
                                    <p>The <code>print()</code> function is one of the most useful functions in Lua.
                                        It can print multiple values separated by commas:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/hello-print-multiple.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-print" />
                                    </jsp:include>

                                    <p>Notice how <code>print()</code> automatically adds spaces between values and a
                                        newline at the end!</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>Description</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Single value</td>
                                                <td>Print one item</td>
                                                <td><code>print("Hello")</code></td>
                                            </tr>
                                            <tr>
                                                <td>Multiple values</td>
                                                <td>Print several items</td>
                                                <td><code>print("A", "B", "C")</code></td>
                                            </tr>
                                            <tr>
                                                <td>Numbers</td>
                                                <td>Print numeric values</td>
                                                <td><code>print(42, 3.14)</code></td>
                                            </tr>
                                            <tr>
                                                <td>Mixed types</td>
                                                <td>Combine strings and numbers</td>
                                                <td><code>print("Age:", 25)</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> You can print an empty line by calling
                                        <code>print()</code>
                                        with no arguments. This is useful for adding spacing in your output!
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Comments -->
                                    <h2>Comments in Lua</h2>
                                    <p>Comments are notes in your code that Lua ignores. They're essential for
                                        explaining
                                        what your code does, both for others and for your future self!</p>

                                    <h3>Single-Line Comments</h3>
                                    <p>Use two dashes (<code>--</code>) for single-line comments:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/hello-comments.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-comments" />
                                    </jsp:include>

                                    <h3>Multi-Line Comments</h3>
                                    <p>For longer comments spanning multiple lines, use <code>--[[</code> to start and
                                        <code>]]</code> to end:
                                    </p>

                                    <pre><code class="language-lua">--[[
This is a multi-line comment.
It can span multiple lines.
Very useful for longer explanations!
]]

print("Comments are helpful!")</code></pre>

                                    <div class="best-practice-box">
                                        <strong>Best Practice:</strong> Write comments to explain <em>why</em> you're
                                        doing something,
                                        not <em>what</em> you're doing. The code itself should be clear enough to show
                                        what it does.
                                        <br><br>
                                        <strong>Good:</strong>
                                        <code>-- Calculate tax for international orders</code><br>
                                        <strong>Bad:</strong> <code>-- Multiply price by 0.15</code>
                                    </div>

                                    <!-- String Basics -->
                                    <h2>String Basics</h2>
                                    <p>Strings are sequences of characters enclosed in quotes. Lua accepts both single
                                        and double quotes:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="lua/hello-strings.lua" />
                                        <jsp:param name="language" value="lua" />
                                        <jsp:param name="editorId" value="compiler-strings" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Escape Sequences:</strong> Use backslash (<code>\</code>) for special
                                        characters:
                                        <ul>
                                            <li><code>\n</code> - New line</li>
                                            <li><code>\t</code> - Tab</li>
                                            <li><code>\"</code> - Double quote</li>
                                            <li><code>\'</code> - Single quote</li>
                                            <li><code>\\</code> - Backslash</li>
                                        </ul>
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Forgetting quotes around strings</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-lua">print(Hello)  -- Error: 'Hello' is not defined</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-lua">print("Hello")  -- Strings need quotes!</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Mismatched quotes</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-lua">print("Hello')  -- Quotes don't match!</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-lua">print("Hello")  -- Both double quotes
print('Hello')  -- Both single quotes</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Forgetting parentheses</h4>
                                        <p><strong>Wrong:</strong></p>
                                        <pre><code class="language-lua">print "Hello"  -- This actually works in Lua!
                      -- But it's better to use parentheses</code></pre>
                                        <p><strong>Correct:</strong></p>
                                        <pre><code class="language-lua">print("Hello")  -- Always use parentheses for clarity</code></pre>
                                    </div>

                                    <div class="warning-box">
                                        <strong>Note:</strong> Lua allows calling functions with a single string
                                        argument without
                                        parentheses (e.g., <code>print "Hello"</code>), but this is considered bad
                                        practice.
                                        Always use parentheses for consistency!
                                    </div>

                                    <!-- Exercise -->
                                    <h2>Exercise: Your Turn!</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Modify the code below to print information about
                                            yourself.</p>

                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Print your name</li>
                                            <li>Print your favorite programming language (Lua, of course! 😊)</li>
                                            <li>Print your age or year you started learning programming</li>
                                            <li>Add comments explaining each line</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="lua/exercises/ex-hello-world.lua" />
                                            <jsp:param name="language" value="lua" />
                                            <jsp:param name="editorId" value="exercise-hello" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-lua">-- Print my name
print("My name is Alice")

-- Print my favorite language
print("I love Lua!")

-- Print when I started programming
print("I started learning in 2024")

-- Print a fun fact
print("Fun fact: Lua means 'moon' in Portuguese! 🌙")</code></pre>
                                        </details>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>print():</strong> Outputs text and values to the console</li>
                                            <li><strong>Strings:</strong> Text enclosed in quotes (<code>"..."</code> or
                                                <code>'...'</code>)</li>
                                            <li><strong>Comments:</strong> Use <code>--</code> for single-line,
                                                <code>--[[ ]]</code> for multi-line</li>
                                            <li><strong>Multiple values:</strong> Separate with commas in
                                                <code>print()</code></li>
                                            <li><strong>Escape sequences:</strong> Use <code>\n</code>, <code>\t</code>,
                                                etc. for special characters</li>
                                        </ul>
                                    </div>

                                    <!-- What's Next -->
                                    <h2>What's Next?</h2>
                                    <p>Great job! You've written your first Lua programs and learned the basics of
                                        output and comments.
                                        In the next lesson, we'll dive into <strong>Variables & Types</strong>—how to
                                        store and work with
                                        different kinds of data in Lua. This is where things get really interesting! 🚀
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="installation.jsp" />
                                    <jsp:param name="prevTitle" value="Installation & Setup" />
                                    <jsp:param name="nextLink" value="variables.jsp" />
                                    <jsp:param name="nextTitle" value="Variables & Types" />
                                    <jsp:param name="currentLessonId" value="hello-world" />
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