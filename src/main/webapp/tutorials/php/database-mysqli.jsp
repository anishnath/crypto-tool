<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "database-mysqli" ); request.setAttribute("currentModule", "Database" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP MySQL & MySQLi - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP MySQL and MySQLi. Learn database connections, queries, and both procedural and OOP approaches.">
            <meta name="keywords"
                content="php mysql, php mysqli, php database connection, php mysqli query, php database">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/database-mysqli.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP MySQL and MySQLi","description":"Learn PHP MySQL and MySQLi database connections","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":["MySQL","MySQLi","Database connection","SQL queries"],"timeRequired":"PT30M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="database-mysqli">
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
                                    <span>MySQL & MySQLi</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP MySQL & MySQLi</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~30 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">MySQL is the most popular database for PHP applications. MySQLi
                                        (MySQL Improved) provides both procedural and object-oriented interfaces for
                                        database operations!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/database-mysqli.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-mysqli" />
                                    </jsp:include>

                                    <h2>MySQLi Connection (Procedural)</h2>
                                    <pre><code class="language-php">&lt;?php
$conn = mysqli_connect('localhost', 'root', '', 'myapp');

if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

echo "Connected successfully";
?&gt;</code></pre>

                                    <h2>MySQLi Connection (OOP)</h2>
                                    <pre><code class="language-php">&lt;?php
$mysqli = new mysqli('localhost', 'root', '', 'myapp');

if ($mysqli->connect_error) {
    die("Connection failed: " . $mysqli->connect_error);
}

echo "Connected successfully";
?&gt;</code></pre>

                                    <h2>Execute Query</h2>
                                    <pre><code class="language-php">&lt;?php
// Procedural
$result = mysqli_query($conn, "SELECT * FROM users");
while ($row = mysqli_fetch_assoc($result)) {
    echo $row['name'];
}

// OOP
$result = $mysqli->query("SELECT * FROM users");
while ($row = $result->fetch_assoc()) {
    echo $row['name'];
}
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>mysqli_connect():</strong> Procedural connection</li>
                                            <li><strong>new mysqli():</strong> OOP connection</li>
                                            <li><strong>mysqli_query():</strong> Execute SQL</li>
                                            <li><strong>fetch_assoc():</strong> Get results</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next, learn about <strong>PDO & CRUD</strong> - the modern way to work with
                                        databases!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="files-permissions.jsp" />
                                    <jsp:param name="prevTitle" value="File Permissions" />
                                    <jsp:param name="nextLink" value="database-pdo.jsp" />
                                    <jsp:param name="nextTitle" value="PDO & CRUD" />
                                    <jsp:param name="currentLessonId" value="database-mysqli" />
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