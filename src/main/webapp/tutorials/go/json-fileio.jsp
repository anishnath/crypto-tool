<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "json-fileio"); request.setAttribute("currentModule", "Packages & Standard Library"); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>JSON & File I/O - Go Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn JSON & File I/O in Go. Free interactive tutorial with examples and exercises.">
            <meta name="keywords"
                content="go tutorial, golang tutorial, json-fileio, learn go, go programming">

            <meta property="og:type" content="article">
            <meta property="og:title" content="JSON & File I/O - Go Tutorial">
            <meta property="og:description" content="Learn JSON & File I/O in Go programming language.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/go/json-fileio.jsp">
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
    "name": "JSON & File I/O - Go Tutorial",
    "description": "Learn JSON & File I/O in Go programming language.",
    "learningResourceType": "Tutorial",
    "educationalLevel": "Intermediate",
    "interactivityType": "active",
    "inLanguage": "en",
    "isAccessibleForFree": true,
    "url": "https://8gwifi.org/tutorials/go/json-fileio.jsp",
    "timeRequired": "PT35M",
    "isPartOf": {
        "@type": "Course",
        "name": "Go Tutorial",
        "description": "Complete Go programming course from beginner to advanced",
        "url": "https://8gwifi.org/tutorials/go/",
        "provider": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
        }
    }
}
            </script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="json-fileio">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>

                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-go.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/go/">Go</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>JSON & File I/O</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">JSON & File I/O</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~35 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">This lesson covers JSON & File I/O in Go programming.</p>

                                    <div class="info-box">
                                        <strong>🚧 Content Coming Soon!</strong>
                                        <p>This lesson is currently under development. The complete content with interactive examples, 
                                        exercises, and detailed explanations will be added soon.</p>
                                    </div>

                                    <h2>What You'll Learn</h2>
                                    <ul>
                                        <li>Core concepts of JSON & File I/O</li>
                                        <li>Practical examples and use cases</li>
                                        <li>Best practices and common patterns</li>
                                        <li>Hands-on exercises</li>
                                    </ul>

                                    <!-- Content will be added here -->

                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="stdlib.jsp" />
                                    <jsp:param name="prevTitle" value="Standard Library" />
                                    <jsp:param name="nextLink" value="generics-reflection.jsp" />
                                    <jsp:param name="nextTitle" value="Generics & Reflection" />
                                    <jsp:param name="currentLessonId" value="<%= request.getAttribute(\"currentLesson\") %>" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-simple.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/go.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>
