<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "prof-args" );
        request.setAttribute("currentModule", "Professional Practices" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Python Command Line Arguments - Tutorial | 8gwifi.org</title>
            <meta name="description" content="Learn Python argparse. Handle command line arguments.">
            <meta name="keywords" content="python argparse, command line arguments, cli">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Python Command Line Arguments - Tutorial">
            <meta property="og:description" content="Master Python argparse: create CLI tools.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/python/prof-args.jsp">
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
        "name": "Python Command Line Arguments",
        "description": "Learn to use Python argparse.",
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

        <body class="tutorial-body no-preview" data-lesson="prof-args">
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
                                    <h1 class="lesson-title">Command Line Arguments</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~10 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">The <code>argparse</code> module makes it easy to write
                                        user-friendly command-line interfaces. It parses the arguments defined in
                                        <code>sys.argv</code>.</p>

                                    <h2>Using argparse</h2>
                                    <p>You define what arguments your program requires, and <code>argparse</code> will
                                        figure out how to parse those out of <code>sys.argv</code>. It also
                                        automatically generates help and usage messages.</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/prof-args.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-prof-args" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Exercise: File Argument</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create a parser that accepts a filename.</p>
                                        <p><strong>Requirements:</strong></p>
                                        <ul>
                                            <li>Add a <code>--file</code> argument.</li>
                                            <li>Print "Processing file: [filename]".</li>
                                        </ul>

                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="python/exercises/ex-prof-args.py" />
                                            <jsp:param name="language" value="python" />
                                            <jsp:param name="editorId" value="exercise-prof-args" />
                                        </jsp:include>

                                        <details class="exercise-hint">
                                            <summary>Show Solution</summary>
                                            <pre><code class="language-python">parser.add_argument("--file", required=True)
# ...
print(f"Processing file: {args.file}")</code></pre>
                                        </details>
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="prof-logging.jsp" />
                                    <jsp:param name="prevTitle" value="Logging" />
                                    <jsp:param name="nextLink" value="prof-sqlite.jsp" />
                                    <jsp:param name="nextTitle" value="SQLite Database" />
                                    <jsp:param name="currentLessonId" value="prof-args" />
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