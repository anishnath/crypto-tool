<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "operators-logical" );
        request.setAttribute("currentModule", "Operators & Expressions" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Logical Operators (&&, ||, !) - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to combine boolean expressions using Java's logical operators: AND (&&), OR (||), and NOT (!). Understand short-circuit evaluation.">
            <meta name="keywords"
                content="java logical operators, java AND operator, java OR operator, java NOT operator, short circuit evaluation, boolean logic">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Logical Operators - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Master Java's logical operators for complex decision making. Includes truth tables and short-circuit logic diagrams.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/operators-logical.jsp">
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
    "name": "Java Logical Operators",
    "description": "Guide to Java logical operators (AND, OR, NOT) and boolean algebra.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Beginner",
    "teaches": ["Logical AND", "Logical OR", "Logical NOT", "Short-circuit evaluation"],
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

        <body class="tutorial-body no-preview" data-lesson="operators-logical">
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
                                    <span>Logical Operators</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Logical Operators</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">Logical operators allow you to combine multiple boolean expressions.
                                        They are essential for creating complex conditions in your programs, like
                                        checking if a user is logged in <strong>AND</strong> has administrative
                                        privileges.</p>

                                    <!-- Section 1: The Operators -->
                                    <h2>The 3 Logical Operators</h2>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Operator</th>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th>Example</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>&&</code></td>
                                                <td>Logical AND</td>
                                                <td>Returns <code>true</code> if <strong>both</strong> operands are
                                                    true.</td>
                                                <td><code>(5 > 3) && (8 > 5)</code> → <code>true</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>||</code></td>
                                                <td>Logical OR</td>
                                                <td>Returns <code>true</code> if <strong>at least one</strong> operand
                                                    is true.</td>
                                                <td><code>(5 > 3) || (5 < 3)</code> → <code>true</code></td>
                                            </tr>
                                            <tr>
                                                <td><code>!</code></td>
                                                <td>Logical NOT</td>
                                                <td>Reverses the boolean state.</td>
                                                <td><code>!(5 > 3)</code> → <code>false</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-logical-truth-tables.svg"
                                        alt="Java Logical Operator Truth Tables" class="diagram-image"
                                        style="max-width: 700px; margin: 2rem auto; display: block;">

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/LogicalOperators.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-logical" />
                                    </jsp:include>

                                    <!-- Section 2: Short-Circuit Evaluation -->
                                    <h2>Short-Circuit Evaluation</h2>
                                    <p>Java's logical operators are "short-circuiting." This means they stop evaluating
                                        as soon as the result is determined.</p>

                                    <div class="info-box">
                                        <ul>
                                            <li><strong>AND (&&):</strong> If the first operand is <code>false</code>,
                                                the result MUST be <code>false</code>. Java won't even evaluate the
                                                second operand.</li>
                                            <li><strong>OR (||):</strong> If the first operand is <code>true</code>, the
                                                result MUST be <code>true</code>. Java won't evaluate the second
                                                operand.</li>
                                        </ul>
                                    </div>

                                    <div class="mistake-box">
                                        <h4>Why Short-Circuiting Matters</h4>
                                        <p>Consider this code:</p>
                                        <pre><code class="language-java">if (object != null && object.callMethod()) { ... }</code></pre>
                                        <p>If <code>object</code> is null, the first check fails (false). Because of
                                            short-circuiting, Java <strong>never executes</strong>
                                            <code>object.callMethod()</code>. If it didn't verify the first part, this
                                            code would crash with a <code>NullPointerException</code>!</p>
                                        <p>If you used a single <code>&</code> (bitwise AND), both sides would run,
                                            causing a crash.</p>
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><code>&&</code> (AND): True only if ALL are true.</li>
                                            <li><code>||</code> (OR): True if ANY are true.</li>
                                            <li><code>!</code> (NOT): Flips true to false, and vice versa.</li>
                                            <li>Logical operators <code>&&</code> and <code>||</code> short-circuit:
                                                they stop evaluation early if possible, which improves performance and
                                                safety.</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/operators-comparison.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/java/operators-bitwise.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Comparison Operators" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Bitwise Operators →" />
                                                <jsp:param name="currentLessonId" value="operators-logical" />
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