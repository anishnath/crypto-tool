<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "constants-basics" );
        request.setAttribute("currentModule", "Variables & Data Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Constants - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP constants: define(), const, magic constants, and best practices. Learn when and how to use constants effectively.">
            <meta name="keywords"
                content="php constants, php define, php const, php magic constants, php constant best practices">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/constants-basics.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Constants","description":"Learn PHP constants including define(), const, and magic constants","learningResourceType":"tutorial","educationalLevel":"Beginner","teaches":["PHP constants","define()","const keyword","Magic constants","Constant best practices"],"timeRequired":"PT20M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="constants-basics">
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
                                    <span>Constants</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Constants</h1>
                                    <div class="lesson-meta"><span>Beginner</span><span>~20 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Constants are like variables that never change. Once defined, their
                                        value remains the same throughout your program. They're perfect for
                                        configuration values, API keys, and other fixed data!</p>

                                    <h2>What Are Constants?</h2>
                                    <p>A <strong>constant</strong> is an identifier for a simple value that cannot be
                                        changed during script execution. Unlike variables:</p>

                                    <ul>
                                        <li>Constants do NOT start with <code>$</code></li>
                                        <li>Constants are automatically global</li>
                                        <li>Constants cannot be redefined or undefined</li>
                                        <li>Constants can only hold scalar values (not arrays or objects in PHP &lt;
                                            5.6)</li>
                                    </ul>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/constants-basics.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-constants" />
                                    </jsp:include>

                                    <h2>Defining Constants: define()</h2>
                                    <p>The <code>define()</code> function creates a constant at runtime:</p>

                                    <pre><code class="language-php">&lt;?php
// Syntax: define(name, value, case_insensitive)
define("SITE_NAME", "8gwifi.org");
define("MAX_USERS", 100);
define("PI", 3.14159);
define("DEBUG_MODE", true);

echo SITE_NAME;  // Output: 8gwifi.org
echo MAX_USERS;  // Output: 100
?&gt;</code></pre>

                                    <div class="info-box">
                                        <strong>Naming Convention:</strong> By convention, constant names are written in
                                        UPPERCASE with underscores separating words (UPPER_SNAKE_CASE).
                                    </div>

                                    <h3>Case-Insensitive Constants (Deprecated)</h3>
                                    <pre><code class="language-php">&lt;?php
// Third parameter makes it case-insensitive (deprecated in PHP 7.3)
define("GREETING", "Hello", true);

echo GREETING;  // Works
echo greeting;  // Also works (but deprecated!)
?&gt;</code></pre>

                                    <div class="warning-box">
                                        <strong>Deprecated:</strong> Case-insensitive constants are deprecated as of PHP
                                        7.3 and removed in PHP 8.0. Always use case-sensitive constants!
                                    </div>

                                    <h2>Defining Constants: const Keyword</h2>
                                    <p>The <code>const</code> keyword defines constants at compile time (PHP 5.3+):</p>

                                    <pre><code class="language-php">&lt;?php
const APP_VERSION = "1.0.0";
const MAX_LOGIN_ATTEMPTS = 3;
const ENABLE_CACHE = true;

echo APP_VERSION;  // Output: 1.0.0
?&gt;</code></pre>

                                    <h3>define() vs const</h3>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>define()</th>
                                                <th>const</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>When defined</td>
                                                <td>Runtime</td>
                                                <td>Compile time</td>
                                            </tr>
                                            <tr>
                                                <td>Inside conditionals</td>
                                                <td>✅ Yes</td>
                                                <td>❌ No</td>
                                            </tr>
                                            <tr>
                                                <td>Expression values</td>
                                                <td>✅ Yes</td>
                                                <td>❌ No (PHP &lt; 5.6)</td>
                                            </tr>
                                            <tr>
                                                <td>Namespace support</td>
                                                <td>❌ No</td>
                                                <td>✅ Yes</td>
                                            </tr>
                                            <tr>
                                                <td>Class constants</td>
                                                <td>❌ No</td>
                                                <td>✅ Yes</td>
                                            </tr>
                                            <tr>
                                                <td>Arrays (PHP 7+)</td>
                                                <td>✅ Yes</td>
                                                <td>✅ Yes</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <pre><code class="language-php">&lt;?php
// define() can be conditional
if ($production) {
    define("DEBUG", false);
} else {
    define("DEBUG", true);
}

// const cannot be conditional
const DEBUG = false;  // ✅ Works at top level
if ($production) {
    const DEBUG = false;  // ❌ Syntax error!
}
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Array Constants (PHP 5.6+)</h2>
                                    <p>Since PHP 5.6, constants can hold arrays:</p>

                                    <pre><code class="language-php">&lt;?php
const COLORS = ["red", "green", "blue"];
define("SIZES", ["small", "medium", "large"]);

echo COLORS[0];  // Output: red
echo SIZES[1];   // Output: medium
?&gt;</code></pre>

                                    <h2>Checking if Constant Exists</h2>
                                    <p>Use <code>defined()</code> to check if a constant is defined:</p>

                                    <pre><code class="language-php">&lt;?php
if (defined("DEBUG_MODE")) {
    echo "Debug mode is defined";
}

// Get constant value safely
$debug = defined("DEBUG_MODE") ? DEBUG_MODE : false;
?&gt;</code></pre>

                                    <h2>Magic Constants</h2>
                                    <p>PHP provides special "magic constants" that change depending on where they're
                                        used:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Constant</th>
                                                <th>Description</th>
                                                <th>Example Value</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>__LINE__</code></td>
                                                <td>Current line number</td>
                                                <td>42</td>
                                            </tr>
                                            <tr>
                                                <td><code>__FILE__</code></td>
                                                <td>Full path and filename</td>
                                                <td>/path/to/file.php</td>
                                            </tr>
                                            <tr>
                                                <td><code>__DIR__</code></td>
                                                <td>Directory of the file</td>
                                                <td>/path/to</td>
                                            </tr>
                                            <tr>
                                                <td><code>__FUNCTION__</code></td>
                                                <td>Function name</td>
                                                <td>myFunction</td>
                                            </tr>
                                            <tr>
                                                <td><code>__CLASS__</code></td>
                                                <td>Class name</td>
                                                <td>MyClass</td>
                                            </tr>
                                            <tr>
                                                <td><code>__METHOD__</code></td>
                                                <td>Class method name</td>
                                                <td>MyClass::myMethod</td>
                                            </tr>
                                            <tr>
                                                <td><code>__NAMESPACE__</code></td>
                                                <td>Current namespace</td>
                                                <td>App\Controllers</td>
                                            </tr>
                                            <tr>
                                                <td><code>__TRAIT__</code></td>
                                                <td>Trait name</td>
                                                <td>MyTrait</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <pre><code class="language-php">&lt;?php
echo "Current file: " . __FILE__;
echo "Current directory: " . __DIR__;
echo "Current line: " . __LINE__;

function myFunction() {
    echo "Function: " . __FUNCTION__;
}

class MyClass {
    public function myMethod() {
        echo "Class: " . __CLASS__;
        echo "Method: " . __METHOD__;
    }
}
?&gt;</code></pre>

                                    <div class="tip-box">
                                        <strong>Pro Tip:</strong> <code>__DIR__</code> is extremely useful for including
                                        files with absolute paths, making your code more portable!
                                    </div>

                                    <h2>Predefined Constants</h2>
                                    <p>PHP has many built-in constants:</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Constant</th>
                                                <th>Description</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>PHP_VERSION</code></td>
                                                <td>PHP version string</td>
                                                <td>"8.2.0"</td>
                                            </tr>
                                            <tr>
                                                <td><code>PHP_OS</code></td>
                                                <td>Operating system</td>
                                                <td>"Linux"</td>
                                            </tr>
                                            <tr>
                                                <td><code>PHP_INT_MAX</code></td>
                                                <td>Largest integer</td>
                                                <td>9223372036854775807</td>
                                            </tr>
                                            <tr>
                                                <td><code>PHP_FLOAT_MAX</code></td>
                                                <td>Largest float</td>
                                                <td>1.7976931348623E+308</td>
                                            </tr>
                                            <tr>
                                                <td><code>true</code></td>
                                                <td>Boolean true</td>
                                                <td>true</td>
                                            </tr>
                                            <tr>
                                                <td><code>false</code></td>
                                                <td>Boolean false</td>
                                                <td>false</td>
                                            </tr>
                                            <tr>
                                                <td><code>null</code></td>
                                                <td>Null value</td>
                                                <td>null</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <pre><code class="language-php">&lt;?php
echo PHP_VERSION;  // Current PHP version
echo PHP_OS;       // Operating system
echo PHP_INT_MAX;  // Maximum integer value
?&gt;</code></pre>

                                    <h2>Class Constants</h2>
                                    <p>Constants can be defined inside classes:</p>

                                    <pre><code class="language-php">&lt;?php
class Database {
    const HOST = "localhost";
    const PORT = 3306;
    const NAME = "mydb";
    
    public function connect() {
        echo "Connecting to " . self::HOST;
    }
}

echo Database::HOST;  // Access from outside
?&gt;</code></pre>

                                    <h2>Best Practices</h2>

                                    <div class="info-box">
                                        <strong>When to Use Constants:</strong>
                                        <ul>
                                            <li>Configuration values (database credentials, API keys)</li>
                                            <li>Fixed mathematical values (PI, E)</li>
                                            <li>Application settings (version, environment)</li>
                                            <li>Status codes or flags</li>
                                            <li>File paths</li>
                                        </ul>
                                    </div>

                                    <div class="tip-box">
                                        <strong>Best Practices:</strong>
                                        <ul>
                                            <li>Use UPPER_SNAKE_CASE for constant names</li>
                                            <li>Prefer <code>const</code> for simple values</li>
                                            <li>Use <code>define()</code> for conditional constants</li>
                                            <li>Group related constants in classes</li>
                                            <li>Document what each constant represents</li>
                                        </ul>
                                    </div>

                                    <h2>Common Mistakes</h2>

                                    <div class="mistake-box">
                                        <h4>1. Using $ with constants</h4>
                                        <pre><code class="language-php">&lt;?php
define("MAX_SIZE", 100);

echo $MAX_SIZE;  // ❌ Undefined variable
echo MAX_SIZE;   // ✅ Correct
?&gt;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>2. Trying to change a constant</h4>
                                        <pre><code class="language-php">&lt;?php
define("VERSION", "1.0");
define("VERSION", "2.0");  // ❌ Warning: already defined

VERSION = "2.0";  // ❌ Parse error
?&gt;</code></pre>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>3. Using const in conditional</h4>
                                        <pre><code class="language-php">&lt;?php
if ($debug) {
    const DEBUG = true;  // ❌ Syntax error!
}

// Use define() instead
if ($debug) {
    define("DEBUG", true);  // ✅ Correct
}
?&gt;</code></pre>
                                    </div>

                                    <h2>Exercise: Configuration Constants</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a configuration system using constants!</p>
                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Define constants for: app name, version, environment</li>
                                            <li>Create database connection constants</li>
                                            <li>Use magic constants to show file info</li>
                                            <li>Check if constants are defined before using</li>
                                        </ul>
                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-php">&lt;?php
// Application constants
const APP_NAME = "MyApp";
const APP_VERSION = "1.0.0";
const ENVIRONMENT = "development";

// Database constants
define("DB_HOST", "localhost");
define("DB_NAME", "myapp_db");
define("DB_USER", "root");
define("DB_PASS", "");

// Display configuration
echo "Application: " . APP_NAME . " v" . APP_VERSION . "\n";
echo "Environment: " . ENVIRONMENT . "\n";
echo "Config file: " . __FILE__ . "\n";

// Safe constant access
if (defined("DB_HOST")) {
    echo "Database: " . DB_HOST . "/" . DB_NAME;
}
?&gt;</code></pre>
                                        </details>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Constants:</strong> Values that never change</li>
                                            <li><strong>No $:</strong> Constants don't use dollar sign</li>
                                            <li><strong>define():</strong> Runtime definition, conditional use</li>
                                            <li><strong>const:</strong> Compile-time definition, class support</li>
                                            <li><strong>Global:</strong> Automatically available everywhere</li>
                                            <li><strong>Magic:</strong> <code>__FILE__</code>, <code>__DIR__</code>,
                                                <code>__LINE__</code>, etc.</li>
                                            <li><strong>defined():</strong> Check if constant exists</li>
                                            <li><strong>Naming:</strong> Use UPPER_SNAKE_CASE</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Congratulations! You've completed Module 2 and mastered variables, data types,
                                        type juggling, strings, and constants. In the next module, we'll dive into
                                        <strong>Operators</strong> - the symbols that let you perform calculations,
                                        comparisons, and logical operations!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="strings-functions.jsp" />
                                    <jsp:param name="prevTitle" value="String Functions" />
                                    <jsp:param name="nextLink" value="operators-arithmetic.jsp" />
                                    <jsp:param name="nextTitle" value="Arithmetic Operators" />
                                    <jsp:param name="currentLessonId" value="constants-basics" />
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