<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "advanced-regex" ); request.setAttribute("currentModule", "Advanced Topics"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Regular Expressions - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn Java Regular Expressions (Regex). Understand Pattern, Matcher, and regex syntax in Java.">
            <meta name="keywords" content="java regex, java regular expressions, java pattern matcher, regex tutorial">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Regular Expressions - Java Tutorial | 8gwifi.org">
            <meta property="og:description" content="Master text processing and pattern matching with Java Regex.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/advanced-regex.jsp">
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
    "name": "Java Regular Expressions",
    "description": "Introduction to Regex in Java.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["Regex Syntax", "Pattern Class", "Matcher Class"],
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

        <body class="tutorial-body no-preview" data-lesson="advanced-regex">
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
                                    <span>Regular Expressions</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Regular Expressions (Regex)</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~20 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Regular Expressions are an API for defining String patterns that can
                                        be used for searching, manipulating, and editing text.</p>

                                    <!-- Section 1: Introduction -->
                                    <h2>The API</h2>
                                    <p>The core classes are in <code>java.util.regex</code>:</p>
                                    <ul>
                                        <li><code>Pattern</code>: A compiled representation of a regular expression.
                                        </li>
                                        <li><code>Matcher</code>: An engine that interprets the pattern and performs
                                            match operations against an input string.</li>
                                    </ul>

                                    <!-- Section 2: Basic Example -->
                                    <h2>Basic Example</h2>
                                    <pre><code class="language-java">import java.util.regex.*;

String text = "This is a java tutorial.";
String patternString = ".*java.*";

Pattern pattern = Pattern.compile(patternString);
Matcher matcher = pattern.matcher(text);

boolean matches = matcher.matches(); // true</code></pre>

                                    <!-- Section 3: Common Syntax -->
                                    <h2>Common Syntax</h2>
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>Expression</th>
                                                <th>Meaning</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>.</code></td>
                                                <td>Any character</td>
                                            </tr>
                                            <tr>
                                                <td><code>^</code></td>
                                                <td>Start of string</td>
                                            </tr>
                                            <tr>
                                                <td><code>$</code></td>
                                                <td>End of string</td>
                                            </tr>
                                            <tr>
                                                <td><code>\d</code></td>
                                                <td>Any digit (0-9)</td>
                                            </tr>
                                            <tr>
                                                <td><code>\w</code></td>
                                                <td>Word character (a-z, A-Z, 0-9, _)</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Section 4: Example -->
                                    <h2>Full Example</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/RegexExample.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-regex" />
                                    </jsp:include>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Regex is a powerful tool for text processing.</li>
                                            <li>Java uses <code>java.util.regex</code> package.</li>
                                            <li>Remember that backslashes <code>\</code> in strings need to be escaped
                                                (e.g., <code>"\\d"</code>).</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <%
                                            String prevLinkUrl = request.getContextPath()
                                                + "/tutorials/java/advanced-reflection.jsp";
                                            String nextLinkUrl = request.getContextPath()
                                                + "/tutorials/java/practices-packages.jsp";
                                        %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Reflection" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Packages →" />
                                                <jsp:param name="currentLessonId" value="advanced-regex" />
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