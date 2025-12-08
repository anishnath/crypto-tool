<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "prof-logging" );
        request.setAttribute("currentModule", "Professional Practices" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Python Logging - Tutorial | 8gwifi.org</title>
            <meta name="description" content="Learn Python Logging. Replace print with logging module.">
            <meta name="keywords" content="python logging, logging module, debug info warning error">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Python Logging - Tutorial">
            <meta property="og:description" content="Master Python Logging: levels, configuration, handlers.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/python/prof-logging.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">

            <script>
                (function () {
                    var theme = localStorage.getItem('tutorial-theme');
                    if (theme === 'dark' || (!theme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
                        document.documentElement.setAttribute('data-theme', 'dark');
                    }
                })();
            </script>

            <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "LearningResource",
        "name": "Python Logging",
        "description": "Learn to use Python Logging module.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Advanced",
        "isPartOf": {
            "@type": "Course",
            "name": "Python Tutorial",
            "url": "https://8gwifi.org/tutorials/python/"
        }
    }
    </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="prof-logging">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>

                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-python.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/python/">Python</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Professional Practices</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Logging</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~10 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Using <code>print()</code> statements for debugging is common, but
                                        for production applications, you should use the <code>logging</code> module. It
                                        provides a flexible way to track events.</p>

                                    <h2>Log Levels</h2>
                                    <p>Logging has different levels of severity:</p>
                                    <ul>
                                        <li><strong>DEBUG</strong>: Detailed info, for diagnosing problems.</li>
                                        <li><strong>INFO</strong>: Confirmation that things are working.</li>
                                        <li><strong>WARNING</strong>: Indication that something unexpected happened.
                                        </li>
                                        <li><strong>ERROR</strong>: Due to a more serious problem, the software has not
                                            been able to perform some function.</li>
                                        <li><strong>CRITICAL</strong>: A serious error, indicating that the program
                                            itself may be unable to continue running.</li>
                                    </ul>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/prof-logging.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-prof-logging" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Exercise: Add Logging</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Add logging to the script.</p>
                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Configure logging to DEBUG level.</li>
                                            <li>Add an INFO log when processing data.</li>
                                            <li>Add a WARNING log if data is empty.</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="python/exercises/ex-prof-logging.py" />
                                            <jsp:param name="language" value="python" />
                                            <jsp:param name="editorId" value="exercise-prof-logging" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-python">logging.basicConfig(level=logging.DEBUG)
logging.info("Processing data")
logging.warning("Data is empty")</code></pre>
                                        </details>
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="prof-testing.jsp" />
                                    <jsp:param name="prevTitle" value="Unit Testing" />
                                    <jsp:param name="nextLink" value="prof-args.jsp" />
                                    <jsp:param name="nextTitle" value="Command Line Args" />
                                    <jsp:param name="currentLessonId" value="prof-logging" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>