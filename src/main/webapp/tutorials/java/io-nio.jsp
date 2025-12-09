<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "io-nio" ); request.setAttribute("currentModule", "File I/O" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java NIO (New I/O) - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Introduction to Java NIO (New I/O). Learn about Path, Files, and non-blocking I/O operations.">
            <meta name="keywords"
                content="java nio, java path, java files class, java non-blocking io, java nio example">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java NIO (New I/O) - Java Tutorial | 8gwifi.org">
            <meta property="og:description" content="Modern file handling with Java NIO (New I/O).">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/io-nio.jsp">
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
    "name": "Java NIO",
    "description": "Guide to Java NIO.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Advanced",
    "teaches": ["Path Interface", "Files Class", "NIO Buffers"],
    "timeRequired": "PT15M",
    "isPartOf": {
        "@type": "Course",
        "name": "Java Tutorial",
        "url": "https://8gwifi.org/tutorials/java/"
    }
}
</script>

            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="io-nio">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>

                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-java.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/java/">Java</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>NIO (New I/O)</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">NIO (New I/O)</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead"><strong>NIO (New I/O)</strong> was introduced in Java 1.4 and
                                        enhanced in Java 7 (NIO.2). It offers a different way of working with I/O than
                                        the standard IO API, including non-blocking IO and a more comprehensive
                                        filesystem interface.</p>

                                    <h2>Key Components</h2>
                                    <ul>
                                        <li><strong>Path:</strong> Replaces <code>java.io.File</code> for file paths.
                                        </li>
                                        <li><strong>Files:</strong> Utility class for file operations (copy, move,
                                            delete, read, write).</li>
                                        <li><strong>Buffers & Channels:</strong> Core of non-blocking I/O.</li>
                                    </ul>

                                    <h2>Example: Copying a File</h2>
                                    <pre><code class="language-java">Path source = Paths.get("source.txt");
Path dest = Paths.get("dest.txt");
try {
    Files.copy(source, dest, StandardCopyOption.REPLACE_EXISTING);
} catch (IOException e) {
    e.printStackTrace();
}</code></pre>

                                    <!-- Example -->
                                    <h2>Full Example</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/io-nio.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-nio" />
                                    </jsp:include>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/io-serialization.jsp" ; String
                                            nextLinkUrl=request.getContextPath() + "/tutorials/java/advanced-lambda.jsp"
                                            ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Serialization" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Lambda Expressions →" />
                                                <jsp:param name="currentLessonId" value="io-nio" />
                                            </jsp:include>
                                    </div>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/clike.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>