<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "forms-get" ); request.setAttribute("currentModule", "Superglobals" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP GET & POST Methods - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP GET and POST methods. Learn form handling, data retrieval, and when to use each method.">
            <meta name="keywords" content="php get post, php form handling, php $_GET, php $_POST, php form methods">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/forms-get.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP GET and POST Methods","description":"Learn PHP form handling with GET and POST","learningResourceType":"tutorial","educationalLevel":"Intermediate","teaches":["PHP GET","PHP POST","Form handling","HTTP methods"],"timeRequired":"PT30M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="forms-get">
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
                                    <span>GET & POST</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP GET & POST Methods</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~30 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">GET and POST are the two main HTTP methods for sending data to the
                                        server. Understanding when and how to use each is crucial for web development!
                                    </p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/forms-get-post.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-forms" />
                                    </jsp:include>

                                    <h2>GET vs POST</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Feature</th>
                                                <th>GET</th>
                                                <th>POST</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Visibility</td>
                                                <td>Visible in URL</td>
                                                <td>Hidden in request body</td>
                                            </tr>
                                            <tr>
                                                <td>Bookmarkable</td>
                                                <td>Yes</td>
                                                <td>No</td>
                                            </tr>
                                            <tr>
                                                <td>Data Size</td>
                                                <td>Limited (~2KB)</td>
                                                <td>Large (MB+)</td>
                                            </tr>
                                            <tr>
                                                <td>Security</td>
                                                <td>Less secure</td>
                                                <td>More secure</td>
                                            </tr>
                                            <tr>
                                                <td>Use Case</td>
                                                <td>Retrieving data</td>
                                                <td>Submitting data</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>GET Method</h2>
                                    <pre><code class="language-php">&lt;?php
// URL: page.php?name=John&age=30
$name = $_GET['name'] ?? 'Guest';
$age = $_GET['age'] ?? 0;

echo "Hello, $name! You are $age years old.";
?&gt;</code></pre>

                                    <h2>POST Method</h2>
                                    <pre><code class="language-php">&lt;?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['username'] ?? '';
    $password = $_POST['password'] ?? '';
    
    // Process login
}
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>GET:</strong> URL parameters, bookmarkable</li>
                                            <li><strong>POST:</strong> Form data, more secure</li>
                                            <li><strong>Always sanitize:</strong> Use htmlspecialchars()</li>
                                            <li><strong>Check method:</strong> $_SERVER['REQUEST_METHOD']</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next, learn about <strong>Form Validation</strong> - ensuring data is correct and
                                        safe!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="superglobals-overview.jsp" />
                                    <jsp:param name="prevTitle" value="Superglobals Overview" />
                                    <jsp:param name="nextLink" value="forms-validation.jsp" />
                                    <jsp:param name="nextTitle" value="Form Validation" />
                                    <jsp:param name="currentLessonId" value="forms-get" />
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