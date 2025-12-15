<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "files-permissions" ); request.setAttribute("currentModule", "Files" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP File Permissions & Security - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP file permissions and security. Learn chmod, file validation, path security, and safe file handling.">
            <meta name="keywords"
                content="php file permissions, php chmod, php file security, php path validation, php safe files">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/files-permissions.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP File Permissions","description":"Learn PHP file permissions and security","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":["File permissions","chmod","File security","Path validation"],"timeRequired":"PT30M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="files-permissions">
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
                                    <span>File Permissions</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP File Permissions & Security</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~30 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">File permissions and security are critical for protecting your
                                        application. Learn to manage permissions and validate file paths safely!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/files-permissions.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-permissions" />
                                    </jsp:include>

                                    <h2>Check Permissions</h2>
                                    <pre><code class="language-php">&lt;?php
$file = 'example.txt';

echo is_readable($file) ? 'Readable' : 'Not readable';
echo is_writable($file) ? 'Writable' : 'Not writable';
echo is_executable($file) ? 'Executable' : 'Not executable';
?&gt;</code></pre>

                                    <h2>Change Permissions</h2>
                                    <pre><code class="language-php">&lt;?php
// chmod(file, permissions)
chmod('file.txt', 0644); // rw-r--r--
chmod('script.sh', 0755); // rwxr-xr-x
?&gt;</code></pre>

                                    <h2>Sanitize Filename</h2>
                                    <pre><code class="language-php">&lt;?php
function sanitizeFilename($filename) {
    $filename = basename($filename);
    $filename = preg_replace('/[^a-zA-Z0-9._-]/', '', $filename);
    return $filename;
}

$safe = sanitizeFilename($_GET['file']);
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>chmod():</strong> Change permissions</li>
                                            <li><strong>is_readable():</strong> Check read access</li>
                                            <li><strong>basename():</strong> Prevent directory traversal</li>
                                            <li><strong>Validate paths:</strong> Always sanitize user input</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Congratulations! You've completed Module 9. Next, dive into <strong>Database
                                            Integration</strong> with MySQL!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="files-json.jsp" />
                                    <jsp:param name="prevTitle" value="JSON Files" />
                                    <jsp:param name="nextLink" value="database-mysqli.jsp" />
                                    <jsp:param name="nextTitle" value="Database Introduction" />
                                    <jsp:param name="currentLessonId" value="files-permissions" />
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