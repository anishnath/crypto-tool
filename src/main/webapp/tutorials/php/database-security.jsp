<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "database-security" ); request.setAttribute("currentModule", "Database" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Database Security & Prepared Statements - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP database security. Learn prepared statements, SQL injection prevention, and secure database practices.">
            <meta name="keywords"
                content="php prepared statements, php sql injection, php database security, php pdo security, php mysqli security">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/database-security.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Database Security","description":"Learn PHP database security and prepared statements","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":["Prepared statements","SQL injection prevention","Database security","Secure coding"],"timeRequired":"PT30M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="database-security">
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
                                    <span>Database Security</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Database Security</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~30 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Database security is critical! Prepared statements protect against
                                        SQL injection - one of the most common and dangerous web vulnerabilities. Always
                                        use them!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/database-security.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-security" />
                                    </jsp:include>

                                    <h2>PDO Prepared Statements</h2>
                                    <pre><code class="language-php">&lt;?php
// SECURE - Named parameters
$sql = "SELECT * FROM users WHERE email = :email";
$stmt = $pdo->prepare($sql);
$stmt->execute(['email' => $_POST['email']]);

// SECURE - Positional parameters
$sql = "SELECT * FROM users WHERE id = ?";
$stmt = $pdo->prepare($sql);
$stmt->execute([1]);
?&gt;</code></pre>

                                    <h2>MySQLi Prepared Statements</h2>
                                    <pre><code class="language-php">&lt;?php
$sql = "SELECT * FROM users WHERE email = ?";
$stmt = $mysqli->prepare($sql);
$stmt->bind_param("s", $_POST['email']); // s = string
$stmt->execute();
$result = $stmt->get_result();
?&gt;</code></pre>

                                    <h2>⚠️ NEVER Do This!</h2>
                                    <pre><code class="language-php">&lt;?php
// VULNERABLE TO SQL INJECTION!
$sql = "SELECT * FROM users WHERE email = '{$_POST['email']}'";
$result = $pdo->query($sql); // DON'T DO THIS!
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Security Best Practices</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>✅ Always use prepared statements</strong></li>
                                            <li><strong>❌ Never concatenate user input into SQL</strong></li>
                                            <li><strong>✅ Validate and sanitize all input</strong></li>
                                            <li><strong>✅ Use appropriate data types</strong></li>
                                            <li><strong>✅ Limit database user permissions</strong></li>
                                            <li><strong>✅ Use HTTPS for sensitive data</strong></li>
                                        </ul>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>Prepared statements:</strong> Prevent SQL injection</li>
                                            <li><strong>PDO:</strong> Use named (:param) or positional (?) parameters
                                            </li>
                                            <li><strong>MySQLi:</strong> Use bind_param()</li>
                                            <li><strong>Never:</strong> Concatenate user input into SQL</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Congratulations! You've completed Module 10 (Database). You now have complete PHP
                                        mastery from basics to databases!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="database-pdo.jsp" />
                                    <jsp:param name="prevTitle" value="PDO & CRUD" />
                                    <jsp:param name="nextLink" value="errors-exceptions.jsp" />
                                    <jsp:param name="nextTitle" value="Error & Exceptions" />
                                    <jsp:param name="currentLessonId" value="database-security" />
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