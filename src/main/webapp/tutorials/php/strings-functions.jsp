<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "strings-functions" );
        request.setAttribute("currentModule", "Variables & Data Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP String Functions - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP string functions: strlen, trim, substr, str_replace, explode, implode, and more. Learn string manipulation and transformation.">
            <meta name="keywords"
                content="php string functions, strlen, substr, str_replace, explode, implode, trim, strtoupper, strtolower">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/strings-functions.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP String Functions","description":"Learn essential PHP string functions for manipulation and transformation","learningResourceType":"tutorial","educationalLevel":"Beginner","teaches":["String functions","strlen","substr","str_replace","explode","implode"],"timeRequired":"PT30M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="strings-functions">
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
                                    <span>String Functions</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP String Functions</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~30 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">PHP provides over 100 built-in string functions for manipulating
                                        text. In this lesson, you'll learn the most essential functions that you'll use
                                        daily in PHP development!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/strings-functions.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-functions" />
                                    </jsp:include>

                                    <h2>String Length</h2>

                                    <h3>strlen() - Get String Length</h3>
                                    <pre><code class="language-php">&lt;?php
$text = "Hello, World!";
echo strlen($text);  // Output: 13

// Useful for validation
$password = "abc123";
if (strlen($password) < 8) {
    echo "Password too short!";
}
?&gt;</code></pre>

                                    <h2>Case Conversion</h2>

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
                                                <td><code>strtoupper()</code></td>
                                                <td>Convert to uppercase</td>
                                                <td><code>strtoupper("hello")</code> → "HELLO"</td>
                                            </tr>
                                            <tr>
                                                <td><code>strtolower()</code></td>
                                                <td>Convert to lowercase</td>
                                                <td><code>strtolower("HELLO")</code> → "hello"</td>
                                            </tr>
                                            <tr>
                                                <td><code>ucfirst()</code></td>
                                                <td>Uppercase first character</td>
                                                <td><code>ucfirst("hello")</code> → "Hello"</td>
                                            </tr>
                                            <tr>
                                                <td><code>lcfirst()</code></td>
                                                <td>Lowercase first character</td>
                                                <td><code>lcfirst("HELLO")</code> → "hELLO"</td>
                                            </tr>
                                            <tr>
                                                <td><code>ucwords()</code></td>
                                                <td>Uppercase first char of each word</td>
                                                <td><code>ucwords("hello world")</code> → "Hello World"</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <pre><code class="language-php">&lt;?php
$name = "john doe";
echo ucwords($name);  // Output: John Doe

// Case-insensitive comparison
$input = "HELLO";
if (strtolower($input) === "hello") {
    echo "Match!";
}
?&gt;</code></pre>

                                    <h2>Trimming Whitespace</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Function</th>
                                                <th>Removes From</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>trim()</code></td>
                                                <td>Both ends</td>
                                                <td><code>trim("  hi  ")</code> → "hi"</td>
                                            </tr>
                                            <tr>
                                                <td><code>ltrim()</code></td>
                                                <td>Left side</td>
                                                <td><code>ltrim("  hi  ")</code> → "hi "</td>
                                            </tr>
                                            <tr>
                                                <td><code>rtrim()</code></td>
                                                <td>Right side</td>
                                                <td><code>rtrim("  hi  ")</code> → " hi"</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <pre><code class="language-php">&lt;?php
$input = "  user@email.com  \n";
$clean = trim($input);  // "user@email.com"

// Trim specific characters
$url = "https://example.com/";
echo rtrim($url, '/');  // Remove trailing slash
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Substring Operations</h2>

                                    <h3>substr() - Extract Part of String</h3>
                                    <pre><code class="language-php">&lt;?php
$text = "Hello, World!";

// substr(string, start, length)
echo substr($text, 0, 5);   // "Hello"
echo substr($text, 7);      // "World!" (from position 7 to end)
echo substr($text, -6);     // "World!" (last 6 characters)
echo substr($text, 0, -7);  // "Hello," (all except last 7)
?&gt;</code></pre>

                                    <h3>str_split() - Split String into Array</h3>
                                    <pre><code class="language-php">&lt;?php
$text = "Hello";
$chars = str_split($text);
print_r($chars);  // ["H", "e", "l", "l", "o"]

// Split into chunks
$chunks = str_split($text, 2);
print_r($chunks);  // ["He", "ll", "o"]
?&gt;</code></pre>

                                    <h2>Search and Replace</h2>

                                    <h3>str_replace() - Replace All Occurrences</h3>
                                    <pre><code class="language-php">&lt;?php
$text = "Hello World, Hello PHP!";

// Replace all "Hello" with "Hi"
$result = str_replace("Hello", "Hi", $text);
echo $result;  // "Hi World, Hi PHP!"

// Multiple replacements
$text = "I like apples and oranges";
$result = str_replace(
    ["apples", "oranges"],
    ["bananas", "grapes"],
    $text
);
echo $result;  // "I like bananas and grapes"

// Count replacements
$count = 0;
str_replace("Hello", "Hi", $text, $count);
echo $count;  // 2
?&gt;</code></pre>

                                    <h3>str_ireplace() - Case-Insensitive Replace</h3>
                                    <pre><code class="language-php">&lt;?php
$text = "Hello HELLO hello";
$result = str_ireplace("hello", "Hi", $text);
echo $result;  // "Hi Hi Hi"
?&gt;</code></pre>

                                    <h2>Finding Substrings</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Function</th>
                                                <th>Returns</th>
                                                <th>Case-Sensitive</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>strpos()</code></td>
                                                <td>Position of first occurrence</td>
                                                <td>Yes</td>
                                            </tr>
                                            <tr>
                                                <td><code>stripos()</code></td>
                                                <td>Position of first occurrence</td>
                                                <td>No</td>
                                            </tr>
                                            <tr>
                                                <td><code>strrpos()</code></td>
                                                <td>Position of last occurrence</td>
                                                <td>Yes</td>
                                            </tr>
                                            <tr>
                                                <td><code>strstr()</code></td>
                                                <td>String from first occurrence</td>
                                                <td>Yes</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <pre><code class="language-php">&lt;?php
$text = "Hello World";

// Find position
$pos = strpos($text, "World");
echo $pos;  // 6

// Check if substring exists
if (strpos($text, "World") !== false) {
    echo "Found!";
}

// Get substring from position
$result = strstr($text, "World");
echo $result;  // "World"
?&gt;</code></pre>

                                    <div class="warning-box">
                                        <strong>Important:</strong> Always use <code>!== false</code> when checking
                                        <code>strpos()</code>. If the substring is at position 0, it returns
                                        <code>0</code> which is falsy!
                                    </div>

                                    <h2>String to Array Conversion</h2>

                                    <h3>explode() - Split String by Delimiter</h3>
                                    <pre><code class="language-php">&lt;?php
$csv = "John,Doe,30,Engineer";
$parts = explode(",", $csv);
print_r($parts);
// ["John", "Doe", "30", "Engineer"]

// Limit splits
$limited = explode(",", $csv, 2);
print_r($limited);
// ["John", "Doe,30,Engineer"]
?&gt;</code></pre>

                                    <h3>implode() - Join Array into String</h3>
                                    <pre><code class="language-php">&lt;?php
$words = ["Hello", "World", "PHP"];
$sentence = implode(" ", $words);
echo $sentence;  // "Hello World PHP"

// Also called join()
$csv = join(",", $words);
echo $csv;  // "Hello,World,PHP"
?&gt;</code></pre>

                                    <h2>String Comparison</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Function</th>
                                                <th>Description</th>
                                                <th>Returns</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>strcmp()</code></td>
                                                <td>Binary safe comparison</td>
                                                <td>&lt;0, 0, or &gt;0</td>
                                            </tr>
                                            <tr>
                                                <td><code>strcasecmp()</code></td>
                                                <td>Case-insensitive comparison</td>
                                                <td>&lt;0, 0, or &gt;0</td>
                                            </tr>
                                            <tr>
                                                <td><code>strncmp()</code></td>
                                                <td>Compare first n characters</td>
                                                <td>&lt;0, 0, or &gt;0</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <pre><code class="language-php">&lt;?php
$str1 = "apple";
$str2 = "Apple";

echo strcmp($str1, $str2);      // > 0 (different)
echo strcasecmp($str1, $str2);  // 0 (same, ignoring case)
?&gt;</code></pre>

                                    <h2>Other Useful Functions</h2>

                                    <h3>str_repeat() - Repeat String</h3>
                                    <pre><code class="language-php">&lt;?php
echo str_repeat("*", 10);  // "**********"
echo str_repeat("Ha", 3);  // "HaHaHa"
?&gt;</code></pre>

                                    <h3>str_pad() - Pad String</h3>
                                    <pre><code class="language-php">&lt;?php
$num = "42";
echo str_pad($num, 5, "0", STR_PAD_LEFT);   // "00042"
echo str_pad($num, 5, "0", STR_PAD_RIGHT);  // "42000"
echo str_pad($num, 6, "-", STR_PAD_BOTH);   // "--42--"
?&gt;</code></pre>

                                    <h3>str_word_count() - Count Words</h3>
                                    <pre><code class="language-php">&lt;?php
$text = "Hello World PHP";
echo str_word_count($text);  // 3

// Get array of words
$words = str_word_count($text, 1);
print_r($words);  // ["Hello", "World", "PHP"]
?&gt;</code></pre>

                                    <h3>strrev() - Reverse String</h3>
                                    <pre><code class="language-php">&lt;?php
echo strrev("Hello");  // "olleH"
?&gt;</code></pre>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Using == instead of === with strpos()</h4>
                                        <pre><code class="language-php">&lt;?php
$text = "Hello World";

if (strpos($text, "Hello") == false) {  // ❌ Wrong!
    // This executes because strpos returns 0 (position)
    // and 0 == false is true
}

if (strpos($text, "Hello") === false) {  // ✅ Correct
    // This won't execute
}
?&gt;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Confusing substr() parameters</h4>
                                        <pre><code class="language-php">&lt;?php
$text = "Hello World";

// Wrong parameter order
substr($text, 5, 0);  // ❌ Empty string

// Correct
substr($text, 0, 5);  // ✅ "Hello"
?&gt;</code></pre>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Length:</strong> <code>strlen()</code></li>
                                            <li><strong>Case:</strong> <code>strtoupper()</code>,
                                                <code>strtolower()</code>, <code>ucwords()</code></li>
                                            <li><strong>Trim:</strong> <code>trim()</code>, <code>ltrim()</code>,
                                                <code>rtrim()</code></li>
                                            <li><strong>Substring:</strong> <code>substr()</code>,
                                                <code>str_split()</code></li>
                                            <li><strong>Replace:</strong> <code>str_replace()</code>,
                                                <code>str_ireplace()</code></li>
                                            <li><strong>Find:</strong> <code>strpos()</code>, <code>strstr()</code></li>
                                            <li><strong>Array:</strong> <code>explode()</code>, <code>implode()</code>
                                            </li>
                                            <li><strong>Compare:</strong> <code>strcmp()</code>,
                                                <code>strcasecmp()</code></li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>You've mastered strings! Now let's learn about <strong>Constants</strong> -
                                        values that never change throughout your program's execution. Perfect for
                                        configuration values, API keys, and more!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="strings-basics.jsp" />
                                    <jsp:param name="prevTitle" value="Strings" />
                                    <jsp:param name="nextLink" value="constants-basics.jsp" />
                                    <jsp:param name="nextTitle" value="Constants" />
                                    <jsp:param name="currentLessonId" value="strings-functions" />
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