<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "intro" ); request.setAttribute("currentModule", "Getting Started" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Introduction to PHP - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn what PHP is, why it's popular for web development, and how it powers millions of websites. Start your PHP journey with interactive examples.">
            <meta name="keywords"
                content="php tutorial, learn php, php for beginners, what is php, php programming, server-side scripting, php basics">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Introduction to PHP - PHP Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Learn what PHP is and start your web development journey with interactive examples.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/php/intro.jsp">
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
        "name": "Introduction to PHP",
        "description": "Learn what PHP is, its history, and why it's one of the most popular server-side languages for web development.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["PHP basics", "Server-side scripting", "PHP history", "PHP use cases", "Web development"],
        "timeRequired": "PT20M",
        "isPartOf": {
            "@type": "Course",
            "name": "PHP Tutorial",
            "url": "https://8gwifi.org/tutorials/php/"
        }
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="intro">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>

                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-php.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/php/">PHP</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Introduction</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Introduction to PHP</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Welcome to PHP! PHP (Hypertext Preprocessor) is one of the most
                                        popular server-side scripting languages, powering over 75% of all websites
                                        including Facebook, WordPress, and Wikipedia. In this lesson, you'll discover
                                        what makes PHP special and why it's an excellent choice for web development.</p>

                                    <!-- Section 1: What is PHP? -->
                                    <h2>What is PHP?</h2>
                                    <p>PHP is a <strong>server-side scripting language</strong> designed specifically
                                        for web development. Unlike HTML which runs in the browser, PHP code executes on
                                        the web server and generates HTML that's sent to the user's browser.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/intro-what-is-php.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-what-is-php" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Fun Fact:</strong> PHP originally stood for "Personal Home Page" when it
                                        was created in 1994 by Rasmus Lerdorf. It was later renamed to "PHP: Hypertext
                                        Preprocessor" - a recursive acronym!
                                    </div>

                                    <!-- Section 2: Server-Side vs Client-Side -->
                                    <h2>Server-Side vs Client-Side</h2>
                                    <p>Understanding the difference between server-side and client-side code is crucial
                                        for web development:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Aspect</th>
                                                <th>Server-Side (PHP)</th>
                                                <th>Client-Side (JavaScript)</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Execution</td>
                                                <td>Runs on the web server</td>
                                                <td>Runs in the user's browser</td>
                                            </tr>
                                            <tr>
                                                <td>Visibility</td>
                                                <td>Code is hidden from users</td>
                                                <td>Code is visible to users</td>
                                            </tr>
                                            <tr>
                                                <td>Use Cases</td>
                                                <td>Database access, file operations, authentication</td>
                                                <td>Interactive UI, animations, form validation</td>
                                            </tr>
                                            <tr>
                                                <td>Security</td>
                                                <td>More secure for sensitive operations</td>
                                                <td>Can be manipulated by users</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="diagram-container" style="margin: 2rem 0; text-align: center;">
                                        <img src="<%=request.getContextPath()%>/tutorials/assets/images/php-client-server.svg"
                                            alt="PHP Client-Server Architecture"
                                            style="max-width: 100%; height: auto; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                                    </div>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/intro-server-side.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-server-side" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> PHP generates the current time on the server, so every
                                        user sees the server's time, not their local time. This is perfect for ensuring
                                        consistency across all users!
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <!-- Section 3: Why Learn PHP? -->
                                    <h2>Why Learn PHP?</h2>
                                    <p>PHP remains incredibly relevant in modern web development for several compelling
                                        reasons:</p>

                                    <ul>
                                        <li><strong>Widespread Adoption:</strong> Powers 75%+ of all websites
                                            (WordPress, Facebook, Wikipedia)</li>
                                        <li><strong>Easy to Learn:</strong> Simple syntax perfect for beginners</li>
                                        <li><strong>Powerful Features:</strong> Built-in functions for databases, files,
                                            sessions, and more</li>
                                        <li><strong>Great Community:</strong> Massive ecosystem of frameworks (Laravel,
                                            Symfony) and libraries</li>
                                        <li><strong>Job Market:</strong> High demand for PHP developers worldwide</li>
                                        <li><strong>Free & Open Source:</strong> No licensing costs</li>
                                    </ul>

                                    <!-- Section 4: What Can PHP Do? -->
                                    <h2>What Can PHP Do?</h2>
                                    <p>PHP is incredibly versatile for web development. Here are some common use cases:
                                    </p>

                                    <div class="info-box">
                                        <strong>PHP Powers:</strong>
                                        <ul>
                                            <li><strong>Dynamic Web Pages:</strong> Generate HTML content based on user
                                                input or database data</li>
                                            <li><strong>Form Processing:</strong> Handle user submissions, validate
                                                data, send emails</li>
                                            <li><strong>Database Operations:</strong> Create, read, update, delete
                                                (CRUD) operations with MySQL, PostgreSQL, etc.</li>
                                            <li><strong>User Authentication:</strong> Login systems, sessions, cookies,
                                                password hashing</li>
                                            <li><strong>File Management:</strong> Upload, download, read, write files on
                                                the server</li>
                                            <li><strong>APIs:</strong> Build RESTful APIs for mobile apps and SPAs</li>
                                            <li><strong>E-commerce:</strong> Shopping carts, payment processing,
                                                inventory management</li>
                                            <li><strong>Content Management:</strong> WordPress, Drupal, Joomla are all
                                                built with PHP</li>
                                        </ul>
                                    </div>

                                    <!-- Section 5: PHP Versions -->
                                    <h2>PHP Versions</h2>
                                    <p>PHP has evolved significantly over the years. Here's what you need to know:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Version</th>
                                                <th>Release Year</th>
                                                <th>Key Features</th>
                                                <th>Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>PHP 5.x</td>
                                                <td>2004-2018</td>
                                                <td>OOP improvements, PDO</td>
                                                <td>❌ End of Life</td>
                                            </tr>
                                            <tr>
                                                <td>PHP 7.x</td>
                                                <td>2015-2022</td>
                                                <td>2x faster, type declarations</td>
                                                <td>⚠️ Security fixes only</td>
                                            </tr>
                                            <tr>
                                                <td>PHP 8.0</td>
                                                <td>2020</td>
                                                <td>JIT compiler, named arguments, union types</td>
                                                <td>✅ Active support</td>
                                            </tr>
                                            <tr>
                                                <td>PHP 8.1</td>
                                                <td>2021</td>
                                                <td>Enums, readonly properties, fibers</td>
                                                <td>✅ Active support</td>
                                            </tr>
                                            <tr>
                                                <td>PHP 8.2</td>
                                                <td>2022</td>
                                                <td>Readonly classes, disjunctive normal form types</td>
                                                <td>✅ Active support</td>
                                            </tr>
                                            <tr>
                                                <td>PHP 8.3</td>
                                                <td>2023</td>
                                                <td>Typed class constants, readonly amendments</td>
                                                <td>✅ Active support</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="warning-box">
                                        <strong>Important:</strong> This tutorial focuses on PHP 8.0+ features while
                                        maintaining compatibility with PHP 7.4. Always use the latest stable version for
                                        new projects!
                                    </div>

                                    <!-- Section 6: Your First PHP Code -->
                                    <h2>Your First PHP Code</h2>
                                    <p>Let's write your very first PHP program! PHP code is enclosed in
                                        <code>&lt;?php ?&gt;</code> tags:
                                    </p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/hello-world.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-hello-world" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Syntax Breakdown:</strong>
                                        <ul>
                                            <li><code>&lt;?php</code> - Opening PHP tag (required)</li>
                                            <li><code>echo</code> - Outputs text to the screen</li>
                                            <li><code>"Hello, World!"</code> - String (text) in quotes</li>
                                            <li><code>;</code> - Semicolon ends each statement</li>
                                            <li><code>?&gt;</code> - Closing PHP tag (optional at end of file)</li>
                                        </ul>
                                    </div>

                                    <!-- Common Mistakes -->
                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Forgetting the PHP tags</h4>
                                        <pre><code class="language-php">// Wrong - no PHP tags
echo "Hello";  // This won't work!

// Correct - wrapped in PHP tags
&lt;?php
echo "Hello";
?&gt;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Missing semicolons</h4>
                                        <pre><code class="language-php">// Wrong - missing semicolon
&lt;?php
echo "Hello"  // Parse error!
?&gt;

// Correct - semicolon at end
&lt;?php
echo "Hello";
?&gt;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Using wrong quotes</h4>
                                        <pre><code class="language-php">// Wrong - using backticks or smart quotes
&lt;?php
echo `Hello`;  // Backticks are for shell commands!
echo "Hello";  // Smart quotes don't work
?&gt;

// Correct - straight quotes
&lt;?php
echo "Hello";  // Double quotes
echo 'Hello';  // Single quotes
?&gt;</code></pre>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>PHP:</strong> Server-side scripting language for web development
                                            </li>
                                            <li><strong>Popularity:</strong> Powers 75%+ of all websites including
                                                WordPress and Facebook</li>
                                            <li><strong>Server-Side:</strong> Code runs on the server, not in the
                                                browser</li>
                                            <li><strong>Use Cases:</strong> Dynamic pages, databases, forms,
                                                authentication, APIs</li>
                                            <li><strong>Modern PHP:</strong> PHP 8.0+ brings major performance and
                                                feature improvements</li>
                                            <li><strong>Syntax:</strong> Code goes inside <code>&lt;?php ?&gt;</code>
                                                tags</li>
                                            <li><strong>echo:</strong> Outputs text to the screen</li>
                                            <li><strong>Semicolons:</strong> Required at the end of each statement</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Now that you understand what PHP is and why it's powerful, it's time to set up
                                        your development environment! In the next lesson, we'll walk through
                                        <strong>installing PHP</strong> on your computer so you can start writing and
                                        testing PHP code locally.
                                    </p>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="" />
                                    <jsp:param name="prevTitle" value="" />
                                    <jsp:param name="nextLink" value="installation.jsp" />
                                    <jsp:param name="nextTitle" value="Installation" />
                                    <jsp:param name="currentLessonId" value="intro" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-simple.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/xml.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/css.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/javascript.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/clike.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/htmlmixed.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/php.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>