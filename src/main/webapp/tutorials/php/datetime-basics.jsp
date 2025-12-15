<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "datetime-basics" ); request.setAttribute("currentModule", "Advanced" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PHP Date & Time - PHP Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master PHP date and time handling. Learn DateTime, formatting, timezones, and date calculations.">
            <meta name="keywords" content="php datetime, php date, php time, php timezone, php date formatting">
            <link rel="canonical" href="https://8gwifi.org/tutorials/php/datetime-basics.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var theme = localStorage.getItem('tutorial-theme'); if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })();</script>
            <script
                type="application/ld+json">{"@context":"https://schema.org","@type":"LearningResource","name":"PHP Date and Time","description":"Learn PHP date and time handling","learningResourceType":"tutorial","educationalLevel":"Advanced","teaches":["DateTime","Date formatting","Timezones","Date calculations"],"timeRequired":"PT25M","isPartOf":{"@type":"Course","name":"PHP Tutorial","url":"https://8gwifi.org/tutorials/php/"}}</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="datetime-basics">
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
                                    <span>Date & Time</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">PHP Date & Time</h1>
                                    <div class="lesson-meta"><span>Advanced</span><span>~25 min read</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Working with dates and times is essential for most applications.
                                        PHP's DateTime class provides powerful tools for date manipulation and
                                        formatting!</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="php/datetime-basics.php" />
                                        <jsp:param name="language" value="php" />
                                        <jsp:param name="editorId" value="compiler-datetime" />
                                    </jsp:include>

                                    <h2>Current Date & Time</h2>
                                    <pre><code class="language-php">&lt;?php
echo date('Y-m-d H:i:s'); // 2025-12-15 12:30:00
echo date('F j, Y');       // December 15, 2025
?&gt;</code></pre>

                                    <h2>DateTime Object</h2>
                                    <pre><code class="language-php">&lt;?php
$now = new DateTime();
echo $now->format('Y-m-d H:i:s');

// Modify date
$now->modify('+7 days');
echo $now->format('Y-m-d');
?&gt;</code></pre>

                                    <h2>Date Difference</h2>
                                    <pre><code class="language-php">&lt;?php
$date1 = new DateTime('2025-01-01');
$date2 = new DateTime('2025-12-31');
$diff = $date1->diff($date2);
echo $diff->days . " days";
?&gt;</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><strong>date():</strong> Format current date</li>
                                            <li><strong>DateTime:</strong> Object-oriented approach</li>
                                            <li><strong>modify():</strong> Add/subtract time</li>
                                            <li><strong>diff():</strong> Calculate difference</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next, learn about <strong>APIs & JSON</strong> - integrating with external
                                        services!</p>
                                </div>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="regex-basics.jsp" />
                                    <jsp:param name="prevTitle" value="Regular Expressions" />
                                    <jsp:param name="nextLink" value="apis-json.jsp" />
                                    <jsp:param name="nextTitle" value="APIs & JSON" />
                                    <jsp:param name="currentLessonId" value="datetime-basics" />
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