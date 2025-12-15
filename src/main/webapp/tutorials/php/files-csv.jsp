<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "files-csv" ); request.setAttribute("currentModule", "Files" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP CSV Files - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP CSV file handling. Learn fputcsv, fgetcsv, and working with comma-separated values.">
            <meta name="keywords"
                content="php csv, php fputcsv, php fgetcsv, php csv file, php read csv, php write csv">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/files-csv.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP CSV Files","description":"Learn PHP CSV file handling","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":["CSV files","fputcsv","fgetcsv","Data import/export"],"timeRequired":"PT25M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="files-csv">
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
                                    <span>CSV Files</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP CSV Files</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~25 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">CSV (Comma-Separated Values) files are perfect for data
                                        import/export. Learn to read and write CSV files with PHP's built-in functions!
                                    </p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/files-csv.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-csv" />
                                    </jsp:include>

                                    <h2>Write CSV</h2>
                                    <pre><code class="language-php">&lt;?php
$data = [
    ['Name', 'Email', 'Age'],
    ['John', 'john@example.com', 30],
    ['Jane', 'jane@example.com', 25]
];

$handle = fopen('users.csv', 'w');
foreach ($data as $row) {
    fputcsv($handle, $row);
}
fclose($handle);
?&gt;</code></pre>

                                    <h2>Read CSV</h2>
                                    <pre><code class="language-php">&lt;?php
$handle = fopen('users.csv', 'r');
while (($row = fgetcsv($handle)) !== false) {
    print_r($row);
}
fclose($handle);
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>fputcsv():</strong> Write CSV row</li>
                                            <li><strong>fgetcsv():</strong> Read CSV row</li>
                                            <li><strong>Headers:</strong> First row as column names</li>
                                            <li><strong>Use case:</strong> Data import/export</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next, learn about <strong>JSON Files</strong> - working with JavaScript Object
                                        Notation!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="directories-basics.jsp" />
                                    <jsp:param name="prevTitle" value="Directory Operations" />
                                    <jsp:param name="nextLink" value="files-json.jsp" />
                                    <jsp:param name="nextTitle" value="JSON Files" />
                                    <jsp:param name="currentLessonId" value="files-csv" />
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