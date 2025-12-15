<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "syntax-basics" ); request.setAttribute("currentModule", "Getting Started"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Syntax Basics - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP syntax fundamentals: statements, semicolons, comments, case sensitivity, and whitespace. Build a solid foundation for PHP programming.">
            <meta name="keywords"
                content="php syntax, php comments, php statements, php case sensitive, php whitespace, php basics">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/syntax-basics.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Syntax Basics","description":"Learn fundamental PHP syntax rules including statements, comments, and case sensitivity","learningResourceType":"tutorial","educationalLevel":"Beginner","teaches":["PHP statements","PHP comments","Case sensitivity","Whitespace rules","PHP syntax"],"timeRequired":"PT20M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="syntax-basics">
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
                                    <span>Syntax Basics</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Syntax Basics</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~20 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Understanding PHP's syntax rules is essential for writing clean,
                                        error-free code. In this lesson, you'll learn about statements, comments, case
                                        sensitivity, and other fundamental syntax rules that govern how PHP code is
                                        written.</p>

                                    <h2>PHP Statements</h2>
                                    <p>A <strong>statement</strong> is a single instruction that tells PHP to do
                                        something. Every statement must end with a semicolon (<code>;</code>):</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/syntax-basics.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-statements" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Statement Rules:</strong>
                                        <ul>
                                            <li>Each statement ends with a semicolon <code>;</code></li>
                                            <li>Statements can span multiple lines</li>
                                            <li>Multiple statements can be on one line (not recommended)</li>
                                            <li>The last statement before <code>?&gt;</code> doesn't need a semicolon
                                                (but it's good practice)</li>
                                        </ul>
                                    </div>

                                    <h2>Comments in PHP</h2>
                                    <p>Comments are notes in your code that PHP ignores. They're crucial for documenting
                                        your code and making it understandable:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/syntax-comments.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-comments" />
                                    </jsp:include>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Comment Type</th>
                                                <th>Syntax</th>
                                                <th>Use Case</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Single-line</strong></td>
                                                <td><code>// comment</code></td>
                                                <td>Short notes, inline explanations</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Single-line (alt)</strong></td>
                                                <td><code># comment</code></td>
                                                <td>Unix-style comments (less common)</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Multi-line</strong></td>
                                                <td><code>/* comment */</code></td>
                                                <td>Longer explanations, multiple lines</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Documentation</strong></td>
                                                <td><code>/** comment */</code></td>
                                                <td>PHPDoc format for functions/classes</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="tip-box">
                                        <strong>Best Practices for Comments:</strong>
                                        <ul>
                                            <li>Explain <em>why</em>, not <em>what</em> (code should be
                                                self-explanatory)</li>
                                            <li>Keep comments up-to-date with code changes</li>
                                            <li>Use PHPDoc for functions and classes</li>
                                            <li>Don't over-comment obvious code</li>
                                        </ul>
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Case Sensitivity</h2>
                                    <p>PHP has specific rules about case sensitivity that you must understand:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/syntax-case-sensitivity.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-case" />
                                    </jsp:include>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Element</th>
                                                <th>Case Sensitive?</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Variables</strong></td>
                                                <td>✅ Yes</td>
                                                <td><code>$name</code> ≠ <code>$Name</code></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Constants</strong></td>
                                                <td>✅ Yes (by default)</td>
                                                <td><code>PI</code> ≠ <code>pi</code></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Functions</strong></td>
                                                <td>❌ No</td>
                                                <td><code>echo</code> = <code>ECHO</code></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Keywords</strong></td>
                                                <td>❌ No</td>
                                                <td><code>if</code> = <code>IF</code></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Class names</strong></td>
                                                <td>❌ No</td>
                                                <td><code>MyClass</code> = <code>myclass</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="warning-box">
                                        <strong>Important:</strong> Even though functions and keywords are
                                        case-insensitive, always use consistent casing! The PHP community standard is
                                        lowercase for keywords and functions.
                                    </div>

                                    <h2>Whitespace and Indentation</h2>
                                    <p>PHP is flexible with whitespace (spaces, tabs, newlines), but proper formatting
                                        makes code readable:</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/syntax-whitespace.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-whitespace" />
                                    </jsp:include>

                                    <div class="info-box">
                                        <strong>Whitespace Rules:</strong>
                                        <ul>
                                            <li>Extra spaces between tokens are ignored</li>
                                            <li>Newlines don't affect code execution</li>
                                            <li>Indentation is for readability only (unlike Python)</li>
                                            <li>Standard: 4 spaces per indentation level</li>
                                        </ul>
                                    </div>

                                    <h2>Code Blocks</h2>
                                    <p>Code blocks group multiple statements together using curly braces
                                        <code>{}</code>:</p>

                                    <pre><code class="language-php">&lt;?php
// Single statement - no braces needed
if (true)
    echo "This works";

// Multiple statements - braces required
if (true) {
    echo "Statement 1";
    echo "Statement 2";
    echo "Statement 3";
}

// Always use braces for clarity (recommended)
if (true) {
    echo "Even for single statements";
}
?&gt;</code></pre>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> Always use curly braces for code blocks, even with
                                        single statements. It prevents bugs when you add more statements later!
                                    </div>

                                    <h2>Naming Conventions</h2>
                                    <p>Following naming conventions makes your code more readable and professional:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Element</th>
                                                <th>Convention</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Variables</strong></td>
                                                <td>camelCase or snake_case</td>
                                                <td><code>$userName</code> or <code>$user_name</code></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Functions</strong></td>
                                                <td>camelCase or snake_case</td>
                                                <td><code>getUserName()</code> or <code>get_user_name()</code></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Classes</strong></td>
                                                <td>PascalCase</td>
                                                <td><code>UserAccount</code></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Constants</strong></td>
                                                <td>UPPER_SNAKE_CASE</td>
                                                <td><code>MAX_SIZE</code></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Files</strong></td>
                                                <td>lowercase, hyphen or underscore</td>
                                                <td><code>user-profile.php</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="info-box">
                                        <strong>PSR Standards:</strong> The PHP community follows PSR (PHP Standard
                                        Recommendations). PSR-12 defines coding style standards. Using these makes your
                                        code compatible with popular frameworks like Laravel and Symfony.
                                    </div>

                                    <h2>Closing PHP Tags</h2>
                                    <p>The closing <code>?&gt;</code> tag has special rules:</p>

                                    <pre><code class="language-php">// File with only PHP - omit closing tag (recommended)
&lt;?php
echo "Hello";
// No closing tag needed

// File with HTML after PHP - use closing tag
&lt;?php
echo "Hello";
?&gt;
&lt;p&gt;This is HTML&lt;/p&gt;</code></pre>

                                    <div class="warning-box">
                                        <strong>Best Practice:</strong> For files containing only PHP code, omit the
                                        closing <code>?&gt;</code> tag. This prevents accidental whitespace from causing
                                        "headers already sent" errors.
                                    </div>

                                    <h2>Common Syntax Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Missing semicolons</h4>
                                        <pre><code class="language-php">&lt;?php
$name = "John"  // ❌ Parse error!
echo $name      // ❌ Parse error!

$name = "John";  // ✅ Correct
echo $name;      // ✅ Correct
?&gt;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Unclosed strings</h4>
                                        <pre><code class="language-php">&lt;?php
echo "Hello;  // ❌ Unclosed string
echo 'World;  // ❌ Unclosed string

echo "Hello";  // ✅ Correct
echo 'World';  // ✅ Correct
?&gt;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Nested comments</h4>
                                        <pre><code class="language-php">&lt;?php
/*
  This is a comment
  /* This won't work! */  // ❌ Can't nest /* */ comments
*/

// Use single-line comments inside multi-line comments
/*
  This is a comment
  // This works fine  ✅
*/
?&gt;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>4. Variable name case mismatch</h4>
                                        <pre><code class="language-php">&lt;?php
$userName = "John";
echo $username;  // ❌ Undefined variable (different case!)

$userName = "John";
echo $userName;  // ✅ Correct
?&gt;</code></pre>
                                    </div>

                                    <h2>Exercise: Clean Code Practice</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Fix the following code to follow proper PHP syntax and
                                            conventions:</p>
                                        <pre><code class="language-php">&lt;?php
// Bad code - fix it!
$firstname = "john"
$LastName = "doe"
ECHO $firstname
echo $lastname
?&gt;</code></pre>
                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-php">&lt;?php
// Fixed code with proper syntax and conventions
$firstName = "John";  // camelCase, capitalized name
$lastName = "Doe";    // Consistent casing
echo $firstName;      // Lowercase echo, semicolon
echo $lastName;       // Correct variable name
// Closing tag omitted for PHP-only files</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Statements:</strong> End with semicolon <code>;</code></li>
                                            <li><strong>Comments:</strong> Use <code>//</code>, <code>#</code>, or
                                                <code>/* */</code> to document code</li>
                                            <li><strong>Case Sensitivity:</strong> Variables are case-sensitive,
                                                functions/keywords are not</li>
                                            <li><strong>Whitespace:</strong> Flexible but use consistent indentation (4
                                                spaces)</li>
                                            <li><strong>Code Blocks:</strong> Use <code>{}</code> to group statements
                                            </li>
                                            <li><strong>Naming:</strong> Follow PSR standards (camelCase for variables,
                                                PascalCase for classes)</li>
                                            <li><strong>Closing Tag:</strong> Omit <code>?&gt;</code> in PHP-only files
                                            </li>
                                            <li><strong>Best Practice:</strong> Write clean, consistent, well-commented
                                                code</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Congratulations! You've completed Module 1 and learned the fundamentals of PHP.
                                        You now know what PHP is, how to install it, write your first programs, and
                                        understand basic syntax rules. In the next module, we'll dive into
                                        <strong>Variables & Data Types</strong> - learning how to store and manipulate
                                        data in PHP. Get ready to make your programs dynamic and interactive!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="first-program.jsp" />
                                    <jsp:param name="prevTitle" value="First Program" />
                                    <jsp:param name="nextLink" value="variables-basics.jsp" />
                                    <jsp:param name="nextTitle" value="Variables" />
                                    <jsp:param name="currentLessonId" value="syntax-basics" />
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