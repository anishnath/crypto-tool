<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "uploads-basics" ); request.setAttribute("currentModule", "Superglobals" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP File Uploads - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP file uploads. Learn $_FILES, move_uploaded_file(), validation, security, and handling multiple files.">
            <meta name="keywords"
                content="php file upload, php $_FILES, php move_uploaded_file, php upload validation, php file security">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/uploads-basics.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP File Uploads","description":"Learn PHP file upload handling","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":["File uploads","$_FILES","move_uploaded_file","Upload validation"],"timeRequired":"PT30M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="uploads-basics">
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
                                    <span>File Uploads</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP File Uploads</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~30 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">File uploads let users submit files to your server. Always validate
                                        file type, size, and name to prevent security vulnerabilities!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/uploads-basics.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-uploads" />
                                    </jsp:include>

                                    <h2>$_FILES Array</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Key</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>$_FILES['file']['name']</code></td>
                                                <td>Original filename</td>
                                            </tr>
                                            <tr>
                                                <td><code>$_FILES['file']['type']</code></td>
                                                <td>MIME type</td>
                                            </tr>
                                            <tr>
                                                <td><code>$_FILES['file']['size']</code></td>
                                                <td>File size in bytes</td>
                                            </tr>
                                            <tr>
                                                <td><code>$_FILES['file']['tmp_name']</code></td>
                                                <td>Temporary location</td>
                                            </tr>
                                            <tr>
                                                <td><code>$_FILES['file']['error']</code></td>
                                                <td>Error code (0 = success)</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Basic Upload</h2>
                                    <pre><code class="language-php">&lt;?php
if (isset($_FILES['upload'])) {
    $file = $_FILES['upload'];
    
    if ($file['error'] === UPLOAD_ERR_OK) {
        $destination = 'uploads/' . $file['name'];
        move_uploaded_file($file['tmp_name'], $destination);
        echo "File uploaded!";
    }
}
?&gt;</code></pre>

                                    <h2>Validation</h2>
                                    <pre><code class="language-php">&lt;?php
// Validate file type
$allowed = ['image/jpeg', 'image/png'];
if (!in_array($file['type'], $allowed)) {
    die("Invalid file type");
}

// Validate size (5MB max)
if ($file['size'] > 5 * 1024 * 1024) {
    die("File too large");
}

// Generate safe filename
$extension = pathinfo($file['name'], PATHINFO_EXTENSION);
$filename = uniqid() . '.' . $extension;
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>$_FILES:</strong> Access uploaded files</li>
                                            <li><strong>move_uploaded_file():</strong> Save file</li>
                                            <li><strong>Validate type:</strong> Check MIME type</li>
                                            <li><strong>Validate size:</strong> Prevent huge files</li>
                                            <li><strong>Generate filename:</strong> Use uniqid()</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Congratulations! You've completed Module 8. Next, dive into <strong>File &
                                            Directory Operations</strong>!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="cookies-basics.jsp" />
                                    <jsp:param name="prevTitle" value="Cookies" />
                                    <jsp:param name="nextLink" value="files-basics.jsp" />
                                    <jsp:param name="nextTitle" value="File Operations" />
                                    <jsp:param name="currentLessonId" value="uploads-basics" />
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