<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "strings-basics" );
        request.setAttribute("currentModule", "Variables & Data Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Strings - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP strings: single quotes, double quotes, heredoc, nowdoc, concatenation, and string interpolation. Learn string manipulation techniques.">
            <meta name="keywords"
                content="php strings, php string concatenation, php heredoc, php nowdoc, php string interpolation">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/strings-basics.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Strings","description":"Learn PHP string syntax, concatenation, interpolation, and manipulation","learningResourceType":"tutorial","educationalLevel":"Beginner","teaches":["PHP strings","String concatenation","String interpolation","Heredoc","Nowdoc"],"timeRequired":"PT25M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="strings-basics">
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
                                    <span>Strings</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Strings</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~25 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Strings are sequences of characters used to store and manipulate
                                        text. PHP offers multiple ways to create strings, each with its own features and
                                        use cases. Let's explore them all!</p>

                                    <h2>String Syntax Options</h2>
                                    <p>PHP provides four ways to create strings:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Type</th>
                                                <th>Syntax</th>
                                                <th>Variables Parsed?</th>
                                                <th>Escape Sequences?</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Single quotes</td>
                                                <td><code>'text'</code></td>
                                                <td>❌ No</td>
                                                <td>Limited</td>
                                            </tr>
                                            <tr>
                                                <td>Double quotes</td>
                                                <td><code>"text"</code></td>
                                                <td>✅ Yes</td>
                                                <td>✅ Yes</td>
                                            </tr>
                                            <tr>
                                                <td>Heredoc</td>
                                                <td><code>&lt;&lt;&lt;EOT</code></td>
                                                <td>✅ Yes</td>
                                                <td>✅ Yes</td>
                                            </tr>
                                            <tr>
                                                <td>Nowdoc</td>
                                                <td><code>&lt;&lt;&lt;'EOT'</code></td>
                                                <td>❌ No</td>
                                                <td>❌ No</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/strings-basics.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-basics" />
                                    </jsp:include>

                                    <h2>Single Quotes</h2>
                                    <p>Single quotes create <strong>literal strings</strong> - what you see is what you
                                        get:</p>

                                    <pre><code class="language-php">&lt;?php
$name = 'John';
echo 'Hello, $name';  // Output: Hello, $name (not parsed!)
echo 'Line 1\nLine 2';  // Output: Line 1\nLine 2 (no newline!)

// Only these escape sequences work:
echo 'It\'s working';  // \' for single quote
echo 'C:\\path\\file';  // \\ for backslash
?&gt;</code></pre>

                                    <div class="tip-box">
                                        <strong>When to use:</strong> Use single quotes for simple strings without
                                        variables or special characters. They're slightly faster than double quotes!
                                    </div>

                                    <h2>Double Quotes</h2>
                                    <p>Double quotes parse variables and escape sequences:</p>

                                    <pre><code class="language-php">&lt;?php
$name = "John";
$age = 25;

echo "Hello, $name!";  // Output: Hello, John!
echo "Age: $age";      // Output: Age: 25

// Escape sequences work
echo "Line 1\nLine 2";  // Actual newline
echo "Tab\there";       // Actual tab
echo "Quote: \"Hi\"";   // Escaped quotes
?&gt;</code></pre>

                                    <h3>Common Escape Sequences</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Sequence</th>
                                                <th>Meaning</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>\n</code></td>
                                                <td>Newline</td>
                                                <td><code>"Line 1\nLine 2"</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>\r</code></td>
                                                <td>Carriage return</td>
                                                <td><code>"Text\r"</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>\t</code></td>
                                                <td>Tab</td>
                                                <td><code>"Name\tAge"</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>\"</code></td>
                                                <td>Double quote</td>
                                                <td><code>"Say \"Hi\""</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>\\</code></td>
                                                <td>Backslash</td>
                                                <td><code>"C:\\path"</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>\$</code></td>
                                                <td>Dollar sign</td>
                                                <td><code>"Price: \$10"</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Variable Interpolation</h2>
                                    <p>Double quotes can embed variables directly:</p>

                                    <pre><code class="language-php">&lt;?php
$name = "John";
$age = 25;

// Simple variable
echo "Name: $name";

// Array element
$user = ["name" => "Jane"];
echo "Name: {$user['name']}";  // Curly braces needed

// Object property
$person = new stdClass();
$person->name = "Bob";
echo "Name: {$person->name}";  // Curly braces needed

// Complex expressions need curly braces
echo "Next year: {$age + 1}";
?&gt;</code></pre>

                                    <div class="warning-box">
                                        <strong>Important:</strong> Use curly braces <code>{$var}</code> for complex
                                        expressions, array elements, or object properties to avoid parsing errors!
                                    </div>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>String Concatenation</h2>
                                    <p>Join strings using the dot operator (<code>.</code>):</p>

                                    <pre><code class="language-php">&lt;?php
$first = "Hello";
$last = "World";

// Concatenation
$combined = $first . " " . $last;
echo $combined;  // Output: Hello World

// Concatenation assignment
$message = "Hello";
$message .= " World";  // Same as: $message = $message . " World"
echo $message;  // Output: Hello World

// Multiple concatenations
$full = "My name is " . $first . " " . $last . "!";
?&gt;</code></pre>

                                    <h2>Heredoc Syntax</h2>
                                    <p>Heredoc is perfect for multi-line strings with variable parsing:</p>

                                    <pre><code class="language-php">&lt;?php
$name = "John";
$age = 25;

$text = &lt;&lt;&lt;EOT
Hello, $name!
You are $age years old.
This is a multi-line string.
No need to escape "quotes" or 'quotes'.
EOT;

echo $text;
?&gt;</code></pre>

                                    <div class="info-box">
                                        <strong>Heredoc Rules:</strong>
                                        <ul>
                                            <li>Start with <code>&lt;&lt;&lt;IDENTIFIER</code></li>
                                            <li>End with <code>IDENTIFIER;</code> on its own line</li>
                                            <li>Closing identifier must have no indentation (PHP &lt; 7.3)</li>
                                            <li>Variables are parsed like double quotes</li>
                                            <li>No need to escape quotes</li>
                                        </ul>
                                    </div>

                                    <h2>Nowdoc Syntax</h2>
                                    <p>Nowdoc is like heredoc but doesn't parse variables (like single quotes):</p>

                                    <pre><code class="language-php">&lt;?php
$name = "John";

$text = &lt;&lt;&lt;'EOT'
Hello, $name!
This $name will NOT be parsed.
Perfect for code examples or templates.
EOT;

echo $text;  // Output: Hello, $name! (literal)
?&gt;</code></pre>

                                    <div class="tip-box">
                                        <strong>When to use Nowdoc:</strong> Use for SQL queries, code examples, or any
                                        multi-line text where you don't want variable parsing.
                                    </div>

                                    <h2>String Access by Character</h2>
                                    <p>Access individual characters using array-like syntax:</p>

                                    <pre><code class="language-php">&lt;?php
$str = "Hello";

echo $str[0];  // Output: H
echo $str[1];  // Output: e
echo $str[-1]; // Output: o (last character, PHP 7.1+)

// Modify characters
$str[0] = 'J';
echo $str;  // Output: Jello
?&gt;</code></pre>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Forgetting curly braces for arrays</h4>
                                        <pre><code class="language-php">&lt;?php
$user = ["name" => "John"];

echo "Name: $user['name']";  // ❌ Parse error!
echo "Name: {$user['name']}";  // ✅ Correct
?&gt;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Mixing quote types</h4>
                                        <pre><code class="language-php">&lt;?php
$text = "Hello';  // ❌ Syntax error!
$text = "Hello";  // ✅ Correct
?&gt;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Heredoc indentation (PHP &lt; 7.3)</h4>
                                        <pre><code class="language-php">&lt;?php
$text = &lt;&lt;&lt;EOT
    Hello
    EOT;  // ❌ Parse error in PHP &lt; 7.3 (indented)

$text = &lt;&lt;&lt;EOT
Hello
EOT;  // ✅ Correct (no indentation)
?&gt;</code></pre>
                                    </div>

                                    <h2>Exercise: String Manipulation</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a formatted email template using strings!</p>
                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Use variables for: recipient name, product name, price</li>
                                            <li>Create a multi-line email using heredoc</li>
                                            <li>Include variable interpolation</li>
                                            <li>Format the price with a dollar sign</li>
                                        </ul>
                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-php">&lt;?php
$recipientName = "Jane Smith";
$productName = "Premium Membership";
$price = 99.99;

$email = &lt;&lt;&lt;EMAIL
Dear $recipientName,

Thank you for your interest in $productName!

Price: \$$price
Special offer: Save 20% today!

Best regards,
The Team
EMAIL;

echo $email;
?&gt;</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Single Quotes:</strong> Literal strings, no variable parsing
                                            </li>
                                            <li><strong>Double Quotes:</strong> Parse variables and escape sequences
                                            </li>
                                            <li><strong>Heredoc:</strong> Multi-line with variable parsing</li>
                                            <li><strong>Nowdoc:</strong> Multi-line without variable parsing</li>
                                            <li><strong>Concatenation:</strong> Use dot operator <code>.</code></li>
                                            <li><strong>Interpolation:</strong> <code>"Hello $name"</code></li>
                                            <li><strong>Complex vars:</strong> Use curly braces
                                                <code>{$arr['key']}</code></li>
                                            <li><strong>Character access:</strong> <code>$str[0]</code></li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Now that you know how to create and work with strings, let's explore
                                        <strong>String Functions</strong> - PHP's powerful built-in functions for
                                        manipulating, searching, and transforming strings!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="types-juggling.jsp" />
                                    <jsp:param name="prevTitle" value="Type Juggling" />
                                    <jsp:param name="nextLink" value="strings-functions.jsp" />
                                    <jsp:param name="nextTitle" value="String Functions" />
                                    <jsp:param name="currentLessonId" value="strings-basics" />
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