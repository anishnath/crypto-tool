<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "database-pdo" ); request.setAttribute("currentModule", "Database" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP PDO & CRUD Operations - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP PDO and CRUD operations. Learn modern database handling with Create, Read, Update, Delete operations.">
            <meta name="keywords"
                content="php pdo, php crud, php database operations, php pdo tutorial, php create read update delete">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/database-pdo.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP PDO and CRUD","description":"Learn PHP PDO and CRUD operations","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":["PDO","CRUD operations","Database management","Modern PHP"],"timeRequired":"PT30M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="database-pdo">
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
                                    <span>PDO & CRUD</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP PDO & CRUD Operations</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~30 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">PDO (PHP Data Objects) is the modern, recommended way to work with
                                        databases. It supports multiple databases and provides a consistent interface
                                        for CRUD operations!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/database-pdo.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-pdo" />
                                    </jsp:include>

                                    <h2>PDO Connection</h2>
                                    <pre><code class="language-php">&lt;?php
try {
    $pdo = new PDO("mysql:host=localhost;dbname=myapp", "root", "");
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Connection failed: " . $e->getMessage());
}
?&gt;</code></pre>

                                    <h2>CRUD Operations</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operation</th>
                                                <th>SQL</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><strong>Create</strong></td>
                                                <td><code>INSERT INTO</code></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Read</strong></td>
                                                <td><code>SELECT</code></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Update</strong></td>
                                                <td><code>UPDATE</code></td>
                                            </tr>
                                            <tr>
                                                <td><strong>Delete</strong></td>
                                                <td><code>DELETE</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Create (Insert)</h2>
                                    <pre><code class="language-php">&lt;?php
$sql = "INSERT INTO users (name, email) VALUES (:name, :email)";
$stmt = $pdo->prepare($sql);
$stmt->execute(['name' => 'John', 'email' => 'john@example.com']);
?&gt;</code></pre>

                                    <h2>Read (Select)</h2>
                                    <pre><code class="language-php">&lt;?php
$stmt = $pdo->query("SELECT * FROM users");
$users = $stmt->fetchAll(PDO::FETCH_ASSOC);
foreach ($users as $user) {
    echo $user['name'];
}
?&gt;</code></pre>

                                    <h2>Update</h2>
                                    <pre><code class="language-php">&lt;?php
$sql = "UPDATE users SET email = :email WHERE id = :id";
$stmt = $pdo->prepare($sql);
$stmt->execute(['email' => 'new@example.com', 'id' => 1]);
?&gt;</code></pre>

                                    <h2>Delete</h2>
                                    <pre><code class="language-php">&lt;?php
$sql = "DELETE FROM users WHERE id = :id";
$stmt = $pdo->prepare($sql);
$stmt->execute(['id' => 1]);
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>PDO:</strong> Modern database interface</li>
                                            <li><strong>CREATE:</strong> INSERT INTO</li>
                                            <li><strong>READ:</strong> SELECT</li>
                                            <li><strong>UPDATE:</strong> UPDATE SET</li>
                                            <li><strong>DELETE:</strong> DELETE FROM</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Finally, learn about <strong>Prepared Statements & Security</strong> - protecting
                                        against SQL injection!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="database-mysqli.jsp" />
                                    <jsp:param name="prevTitle" value="MySQL & MySQLi" />
                                    <jsp:param name="nextLink" value="database-security.jsp" />
                                    <jsp:param name="nextTitle" value="Database Security" />
                                    <jsp:param name="currentLessonId" value="database-pdo" />
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