<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "files-advanced" ); request.setAttribute("currentModule", "Files" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Advanced File Operations - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP advanced file operations. Learn fopen, fread, fwrite, file modes, and file pointers.">
            <meta name="keywords" content="php fopen, php fread, php fwrite, php file modes, php file pointer">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/files-advanced.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Advanced File Operations","description":"Learn advanced PHP file handling","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":["fopen","fread","fwrite","File modes"],"timeRequired":"PT30M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="files-advanced">
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
                                    <span>Advanced File Operations</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Advanced File Operations</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~30 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Advanced file operations give you fine-grained control over file
                                        handling. Perfect for large files, streaming, and precise file manipulation!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/files-advanced.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-advanced" />
                                    </jsp:include>

                                    <h2>File Modes</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Mode</th>
                                                <th>Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>r</code></td>
                                                <td>Read only</td>
                                            </tr>
                                            <tr>
                                                <td><code>w</code></td>
                                                <td>Write only (truncates)</td>
                                            </tr>
                                            <tr>
                                                <td><code>a</code></td>
                                                <td>Append only</td>
                                            </tr>
                                            <tr>
                                                <td><code>r+</code></td>
                                                <td>Read and write</td>
                                            </tr>
                                            <tr>
                                                <td><code>w+</code></td>
                                                <td>Read and write (truncates)</td>
                                            </tr>
                                            <tr>
                                                <td><code>a+</code></td>
                                                <td>Read and append</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Reading with fopen</h2>
                                    <pre><code class="language-php">&lt;?php
$handle = fopen('example.txt', 'r');
while (($line = fgets($handle)) !== false) {
    echo $line;
}
fclose($handle);
?&gt;</code></pre>

                                    <h2>Writing with fopen</h2>
                                    <pre><code class="language-php">&lt;?php
$handle = fopen('output.txt', 'w');
fwrite($handle, "Line 1\n");
fwrite($handle, "Line 2\n");
fclose($handle);
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>fopen():</strong> Open file with mode</li>
                                            <li><strong>fread():</strong> Read bytes</li>
                                            <li><strong>fwrite():</strong> Write data</li>
                                            <li><strong>fclose():</strong> Always close files</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next, learn about <strong>Directory Operations</strong> - creating and managing
                                        folders!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="files-basics.jsp" />
                                    <jsp:param name="prevTitle" value="File Basics" />
                                    <jsp:param name="nextLink" value="directories-basics.jsp" />
                                    <jsp:param name="nextTitle" value="Directory Operations" />
                                    <jsp:param name="currentLessonId" value="files-advanced" />
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