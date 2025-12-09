<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "advanced-streams" );
        request.setAttribute("currentModule", "Advanced Topics" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Streams API - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn the Java Streams API. Process collections of data declaratively using filter, map, and reduce operations.">
            <meta name="keywords"
                content="java streams api, java filter map reduce, stream processing java, java 8 streams, parallel stream">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Streams API - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Efficiently process sequences of elements with the Java Streams API.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/advanced-streams.jsp">
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
    "name": "Java Streams API",
    "description": "Guide to using Streams in Java.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Advanced",
    "teaches": ["Stream Basics", "Filtering and Mapping", "Collecting Results"],
    "timeRequired": "PT20M",
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

        <body class="tutorial-body no-preview" data-lesson="advanced-streams">
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
                                    <span>Streams API</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Streams API</h1>
                                    <div class="lesson-meta">
                                        <span>Advanced</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">A <strong>Stream</strong> in Java is a sequence of objects that
                                        supports various methods which can be pipelined to produce the desired result.
                                        It allows you to process data <em>declaratively</em>.</p>

                                    <!-- Section 1: How Stream Works -->
                                    <h2>How Stream Works</h2>
                                    <p>A Stream pipeline consists of three parts:</p>
                                    <ol>
                                        <li><strong>Source:</strong> Collections, Arrays, or I/O channels.</li>
                                        <li><strong>Intermediate Operations:</strong> Transform the stream (e.g.,
                                            <code>filter</code>, <code>map</code>, <code>sorted</code>). These are lazy!
                                        </li>
                                        <li><strong>Terminal Operation:</strong> Produces a result (e.g.,
                                            <code>forEach</code>, <code>collect</code>, <code>count</code>).</li>
                                    </ol>

                                    <!-- Section 2: Common Operations -->
                                    <h3>1. Filter</h3>
                                    <p>Selects elements based on a condition (Predicate).</p>
                                    <pre><code class="language-java">list.stream().filter(s -> s.startsWith("A"))</code></pre>

                                    <h3>2. Map</h3>
                                    <p>Transforms each element (Function).</p>
                                    <pre><code class="language-java">list.stream().map(s -> s.toUpperCase())</code></pre>

                                    <h3>3. Collect</h3>
                                    <p>Gathers the result into a Collection.</p>
                                    <pre><code class="language-java">.collect(Collectors.toList())</code></pre>

                                    <!-- Section 3: Example -->
                                    <h2>Full Example</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/StreamExample.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-streams" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Streams make code readable and concise.</li>
                                            <li>They do not store data; they process it.</li>
                                            <li>Intermediate operations are lazy (nothing happens until a terminal op is
                                                called).</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/advanced-lambda.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/advanced-threading.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Lambda Expressions" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Threading Basics →" />
                                                <jsp:param name="currentLessonId" value="advanced-streams" />
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