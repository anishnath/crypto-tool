<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "first-program" ); request.setAttribute("currentModule", "Getting Started"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Your First PHP Program - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Write and run your first PHP program. Learn about PHP tags, echo statement, and how to execute PHP code on a web server.">
            <meta name="keywords"
                content="first php program, php hello world, php echo, php tags, run php code, php basics">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/first-program.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"Your First PHP Program","description":"Write and run your first PHP program with interactive examples","learningResourceType":"tutorial","educationalLevel":"Beginner","teaches":["PHP tags","echo statement","Running PHP code","PHP file structure"],"timeRequired":"PT20M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="first-program">
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
                                    <span>First Program</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Your First PHP Program</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~20 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Let's write your first PHP program! You'll learn how to create a PHP
                                        file, understand the basic structure, and see your code come to life in the
                                        browser.</p>

                                    <h2>The Classic "Hello, World!"</h2>
                                    <p>Every programming journey starts with "Hello, World!" - a simple program that
                                        displays text. Here's how it looks in PHP:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/hello-world.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-hello" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Code Breakdown:</strong>
                                        <ul>
                                            <li><code>&lt;?php</code> - Opening PHP tag (tells server "PHP code starts
                                                here")</li>
                                            <li><code>echo</code> - Outputs text to the browser</li>
                                            <li><code>"Hello, World!"</code> - String (text) enclosed in quotes</li>
                                            <li><code>;</code> - Semicolon ends the statement</li>
                                        </ul>
                                    </div>

                                    <h2>PHP Tags Explained</h2>
                                    <p>PHP code must be wrapped in special tags so the server knows what to execute:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Tag Type</th>
                                                <th>Syntax</th>
                                                <th>Usage</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Standard (Recommended)</strong></td>
                                                <td><code>&lt;?php ... ?&gt;</code></td>
                                                <td>Always works, most portable</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Short Echo</strong></td>
                                                <td><code>&lt;?= ... ?&gt;</code></td>
                                                <td>Shortcut for echo, PHP 5.4+</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Short Tags</strong></td>
                                                <td><code>&lt;? ... ?&gt;</code></td>
                                                <td>Deprecated, avoid using</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="warning-box">
                                        <strong>Important:</strong> Always use <code>&lt;?php</code> for maximum
                                        compatibility. Short tags may not work on all servers!
                                    </div>

                                    <h2>The echo Statement</h2>
                                    <p><code>echo</code> is PHP's primary way to output content. It can display text,
                                        numbers, HTML, and more:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/first-program.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-echo" />
                                    </jsp:include>

                                    <div class="tip-box">
                                        <strong>echo vs print:</strong> PHP has both <code>echo</code> and
                                        <code>print</code>. They're nearly identical, but <code>echo</code> is slightly
                                        faster and can output multiple values. Most developers use <code>echo</code>.
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Mixing PHP with HTML</h2>
                                    <p>One of PHP's superpowers is seamlessly mixing with HTML. You can switch between
                                        HTML and PHP as needed:</p>

                                    <pre><code class="language-php">&lt;!DOCTYPE html&gt;
&lt;html&gt;
&lt;head&gt;
    &lt;title&gt;My PHP Page&lt;/title&gt;
&lt;/head&gt;
&lt;body&gt;
    &lt;h1&gt;Welcome!&lt;/h1&gt;
    
    &lt;?php
    echo "&lt;p&gt;This paragraph was generated by PHP!&lt;/p&gt;";
    echo "&lt;p&gt;The current time is: " . date("H:i:s") . "&lt;/p&gt;";
    ?&gt;
    
    &lt;p&gt;This is regular HTML&lt;/p&gt;
&lt;/body&gt;
&lt;/html&gt;</code></pre>

                                    <div class="info-box">
                                        <strong>How It Works:</strong> The server processes PHP code first, replacing it
                                        with output, then sends pure HTML to the browser. The browser never sees your
                                        PHP code!
                                    </div>

                                    <h2>Creating Your First PHP File</h2>
                                    <p>Follow these steps to create and run your first PHP file:</p>

                                    <ol>
                                        <li><strong>Create a new file</strong> named <code>hello.php</code></li>
                                        <li><strong>Save it</strong> in your web server's document root:
                                            <ul>
                                                <li>XAMPP Windows: <code>C:\xampp\htdocs\hello.php</code></li>
                                                <li>XAMPP Mac: <code>/Applications/XAMPP/htdocs/hello.php</code></li>
                                                <li>XAMPP Linux: <code>/opt/lampp/htdocs/hello.php</code></li>
                                            </ul>
                                        </li>
                                        <li><strong>Add this code:</strong>
                                            <pre><code class="language-php">&lt;?php
echo "Hello from my first PHP file!";
?&gt;</code></pre>
                                        </li>
                                        <li><strong>Start your web server</strong> (Apache in XAMPP)</li>
                                        <li><strong>Open your browser</strong> and visit:
                                            <code>http://localhost/hello.php</code></li>
                                    </ol>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> PHP files must have the <code>.php</code> extension.
                                        Files with <code>.html</code> extension won't be processed by PHP!
                                    </div>

                                    <h2>Understanding How PHP Executes</h2>
                                    <p>Here's what happens when you visit a PHP page:</p>

                                    <ol>
                                        <li>Browser requests <code>hello.php</code> from the server</li>
                                        <li>Apache web server sees the <code>.php</code> extension</li>
                                        <li>Server passes the file to PHP interpreter</li>
                                        <li>PHP executes the code and generates output</li>
                                        <li>Server sends the output (HTML) to your browser</li>
                                        <li>Browser displays the result</li>
                                    </ol>

                                    <div class="info-box">
                                        <strong>Key Point:</strong> PHP runs on the SERVER, not in the browser. This
                                        means:
                                        <ul>
                                            <li>Users can't see your PHP source code</li>
                                            <li>PHP can access server resources (databases, files)</li>
                                            <li>You need a web server to run PHP (can't just open .php files in browser)
                                            </li>
                                        </ul>
                                    </div>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Opening .php files directly in browser</h4>
                                        <pre><code>// Wrong - opening file directly
file:///C:/xampp/htdocs/hello.php  ❌

// Correct - through web server
http://localhost/hello.php  ✅</code></pre>
                                        <p>PHP must be processed by a web server. Opening files directly shows the
                                            source code!</p>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Forgetting the closing semicolon</h4>
                                        <pre><code class="language-php">&lt;?php
echo "Hello"  // ❌ Parse error!
?&gt;

&lt;?php
echo "Hello";  // ✅ Correct
?&gt;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Mixing up quotes</h4>
                                        <pre><code class="language-php">&lt;?php
echo "Hello';  // ❌ Mismatched quotes
echo 'Hello";  // ❌ Mismatched quotes

echo "Hello";  // ✅ Matching double quotes
echo 'Hello';  // ✅ Matching single quotes
?&gt;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>4. Wrong file extension</h4>
                                        <pre><code>hello.html  ❌ Won't execute PHP code
hello.txt   ❌ Won't execute PHP code
hello.php   ✅ Correct!</code></pre>
                                    </div>

                                    <h2>Exercise: Personalized Greeting</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a PHP program that displays a personalized
                                            greeting with the current date and time.</p>
                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Display "Welcome to PHP Programming!"</li>
                                            <li>Show your name</li>
                                            <li>Display the current date using <code>date("Y-m-d")</code></li>
                                            <li>Display the current time using <code>date("H:i:s")</code></li>
                                        </ul>
                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-php">&lt;?php
echo "Welcome to PHP Programming!";
echo "\n";
echo "My name is John Doe";
echo "\n";
echo "Today's date: " . date("Y-m-d");
echo "\n";
echo "Current time: " . date("H:i:s");
?&gt;</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>PHP Tags:</strong> Use <code>&lt;?php ... ?&gt;</code> to wrap
                                                PHP code</li>
                                            <li><strong>echo:</strong> Outputs content to the browser</li>
                                            <li><strong>Semicolons:</strong> Required at the end of each statement</li>
                                            <li><strong>File Extension:</strong> PHP files must end with
                                                <code>.php</code></li>
                                            <li><strong>Execution:</strong> PHP runs on the server, not in the browser
                                            </li>
                                            <li><strong>Access:</strong> Use <code>http://localhost/filename.php</code>,
                                                not file://</li>
                                            <li><strong>Mixing:</strong> PHP and HTML can be mixed in the same file</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Congratulations on running your first PHP program! In the next lesson, we'll dive
                                        deeper into <strong>PHP syntax basics</strong> - comments, statements, case
                                        sensitivity, and the fundamental rules of writing clean PHP code.</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="installation.jsp" />
                                    <jsp:param name="prevTitle" value="Installation" />
                                    <jsp:param name="nextLink" value="syntax-basics.jsp" />
                                    <jsp:param name="nextTitle" value="Syntax Basics" />
                                    <jsp:param name="currentLessonId" value="first-program" />
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