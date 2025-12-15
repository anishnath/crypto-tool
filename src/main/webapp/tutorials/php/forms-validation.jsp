<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "forms-validation" ); request.setAttribute("currentModule", "Superglobals"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Form Validation - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP form validation. Learn to validate required fields, email, length, and sanitize user input for security.">
            <meta name="keywords"
                content="php form validation, php validate email, php sanitize input, php filter_var, php validation functions">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/forms-validation.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Form Validation","description":"Learn PHP form validation techniques","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":["Form validation","Input sanitization","Email validation","Security"],"timeRequired":"PT30M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="forms-validation">
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
                                    <span>Form Validation</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Form Validation</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~30 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Form validation ensures data is correct, complete, and safe before
                                        processing. Never trust user input - always validate and sanitize!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/forms-validation.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-validation" />
                                    </jsp:include>

                                    <h2>Common Validations</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Validation</th>
                                                <th>Function</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Required field</td>
                                                <td><code>!empty(trim($value))</code></td>
                                            </tr>
                                            <tr>
                                                <td>Email</td>
                                                <td><code>filter_var($email, FILTER_VALIDATE_EMAIL)</code></td>
                                            </tr>
                                            <tr>
                                                <td>Length</td>
                                                <td><code>strlen($value) >= $min && <= $max</code></td>
                                            </tr>
                                            <tr>
                                                <td>Numeric</td>
                                                <td><code>is_numeric($value)</code></td>
                                            </tr>
                                            <tr>
                                                <td>URL</td>
                                                <td><code>filter_var($url, FILTER_VALIDATE_URL)</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Validate Email</h2>
                                    <pre><code class="language-php">&lt;?php
function validateEmail($email) {
    return filter_var($email, FILTER_VALIDATE_EMAIL) !== false;
}

if (validateEmail("user@example.com")) {
    echo "Valid email";
}
?&gt;</code></pre>

                                    <h2>Sanitize Input</h2>
                                    <pre><code class="language-php">&lt;?php
// Prevent XSS attacks
$name = htmlspecialchars($_POST['name']);

// Remove HTML tags
$text = strip_tags($_POST['text']);

// Sanitize email
$email = filter_var($_POST['email'], FILTER_SANITIZE_EMAIL);
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Always validate:</strong> Never trust user input</li>
                                            <li><strong>filter_var():</strong> Built-in validation</li>
                                            <li><strong>htmlspecialchars():</strong> Prevent XSS</li>
                                            <li><strong>Collect errors:</strong> Show all issues at once</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next, learn about <strong>Sessions</strong> - maintaining user state across
                                        pages!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="forms-get.jsp" />
                                    <jsp:param name="prevTitle" value="GET & POST" />
                                    <jsp:param name="nextLink" value="sessions-basics.jsp" />
                                    <jsp:param name="nextTitle" value="Sessions" />
                                    <jsp:param name="currentLessonId" value="forms-validation" />
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