<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "advanced-datetime" );
        request.setAttribute("currentModule", "Advanced Topics" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Date and Time API - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn the modern Java Date and Time API (java.time). LocalDate, LocalTime, LocalDateTime, and ZonedDateTime.">
            <meta name="keywords"
                content="java date time api, java 8 date, localdate, localtime, zoneddatetime, java time format">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Date and Time API - Java Tutorial | 8gwifi.org">
            <meta property="og:description" content="Master the powerful and immutable Java Date and Time API.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/advanced-datetime.jsp">
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
    "name": "Java Date and Time API",
    "description": "Introduction to java.time API.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["LocalDate", "LocalDateTime", "Formatting"],
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

        <body class="tutorial-body no-preview" data-lesson="advanced-datetime">
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
                                    <span>Date & Time API</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Date & Time API</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Java 8 introduced a new Date and Time API in the
                                        <code>java.time</code> package. It cures the headaches of the old
                                        <code>java.util.Date</code>.
                                    </p>

                                    <!-- Section 1: Main Classes -->
                                    <h2>Main Classes</h2>
                                    <ul>
                                        <li><code>LocalDate</code>: Date without time (e.g., 2023-12-25)</li>
                                        <li><code>LocalTime</code>: Time without date (e.g., 14:30:00)</li>
                                        <li><code>LocalDateTime</code>: Both date and time.</li>
                                        <li><code>ZonedDateTime</code>: Date and time with timezone.</li>
                                    </ul>

                                    <!-- Section 2: Creating Dates -->
                                    <h2>Creating Dates</h2>
                                    <pre><code class="language-java">import java.time.*;

LocalDate today = LocalDate.now();
LocalDate independenceDay = LocalDate.of(1776, Month.JULY, 4);

System.out.println(today); // 202X-MM-DD</code></pre>

                                    <!-- Section 3: Formatting -->
                                    <h2>Formatting</h2>
                                    <p>Use <code>DateTimeFormatter</code>.</p>
                                    <pre><code class="language-java">import java.time.format.DateTimeFormatter;

DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
String formattedDate = today.format(formatter);</code></pre>

                                    <!-- Section 4: Example -->
                                    <h2>Full Example</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/DateTimeExample.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-datetime" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>The new API is <strong>Immutable</strong> and
                                                <strong>Thread-safe</strong>.
                                            </li>
                                            <li>Use <code>LocalDate</code>/<code>LocalTime</code> for most logic.</li>
                                            <li>Use <code>ZonedDateTime</code> only providing timezone support.</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <%
                                            String prevLinkUrl = request.getContextPath()
                                                + "/tutorials/java/advanced-regex.jsp";
                                            String nextLinkUrl = request.getContextPath()
                                                + "/tutorials/java/practices-packages.jsp";
                                        %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Regular Expressions" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Code Organization →" />
                                                <jsp:param name="currentLessonId" value="advanced-datetime" />
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