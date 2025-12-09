<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "control-switch" ); request.setAttribute("currentModule", "Control Flow" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Switch Statements - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn how to use Java Switch Statements for cleaner multi-way branching. Covers traditional switch-case, the break keyword, and new Switch Expressions.">
            <meta name="keywords"
                content="java switch statement, java switch case, java switch break, java switch default, java switch expressions, java control flow">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Switch Statements - Java Tutorial | 8gwifi.org">
            <meta property="og:description"
                content="Master the Switch statement in Java. Replace long if-else chains with clean, readable switch cases.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/control-switch.jsp">
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
    "name": "Java Switch Statements",
    "description": "Guide to Java switch-case statements and switch expressions.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Beginner",
    "teaches": ["Switch statement", "Case label", "Break keyword", "Default case", "Switch Expressions"],
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

        <body class="tutorial-body no-preview" data-lesson="control-switch">
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
                                    <span>Switch Statements</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Switch Statements</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead">The <code>switch</code> statement is an alternative to long chains
                                        of <code>else-if</code> statements. It selects one of many code blocks to be
                                        executed based on the value of a variable.</p>

                                    <!-- Section 1: Traditional Switch -->
                                    <h2>Traditional Switch Syntax</h2>
                                    <p>It checks a variable against a list of values (cases). When a match is found, the
                                        code for that case is executed.</p>

                                    <div class="code-box">
                                        <pre><code class="language-java">switch (variable) {
    case value1:
        // Code
        break;
    case value2:
        // Code
        break;
    default:
        // Code if no match (optional)
}</code></pre>
                                    </div>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/java-flow-switch.svg"
                                        alt="Java Switch Flowchart" class="diagram-image"
                                        style="max-width: 500px; margin: 2rem auto; display: block;">

                                    <div class="warning-box">
                                        <strong>The <code>break</code> Keyword:</strong> This is critical. Without
                                        <code>break</code>, execution "falls through" to the next case, even if it
                                        doesn't match!
                                    </div>

                                    <!-- Section 2: Supported Types -->
                                    <h2>Supported Data Types</h2>
                                    <p>You can use <code>switch</code> with:</p>
                                    <ul>
                                        <li><code>byte</code>, <code>short</code>, <code>char</code>, <code>int</code>
                                        </li>
                                        <li><code>String</code> (since Java 7)</li>
                                        <li><code>Enums</code></li>
                                    </ul>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/SwitchStatement.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-switch" />
                                    </jsp:include>

                                    <!-- Section 3: Modern Switch (Java 14+) -->
                                    <h2>Modern Switch Expressions (Java 14+)</h2>
                                    <p>Modern Java introduced a cleaner syntax that eliminates the need for
                                        <code>break</code> statements and can return values directly.</p>

                                    <pre><code class="language-java">// Old Way
String dayType;
switch (day) {
    case "Sat":
    case "Sun":
        dayType = "Weekend";
        break;
    default:
        dayType = "Weekday";
}

// New Way (Arrow Syntax)
String dayType = switch (day) {
    case "Sat", "Sun" -> "Weekend"; // Multiple labels, no fall-through
    default -> "Weekday";
};</code></pre>

                                    <div class="tip-box">
                                        <strong>Best Practice:</strong> Use the new Arrow Syntax (<code>-></code>)
                                        whenever you are using a recent version of Java. It's concise and less
                                        error-prone.
                                    </div>

                                    <!-- Summary -->
                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Use <code>switch</code> for selecting one path among many fixed options
                                                (like menu items, days of week).</li>
                                            <li>In traditional switch, always remember the <code>break</code> keyword to
                                                stop execution.</li>
                                            <li>The <code>default</code> case runs if no other case matches.</li>
                                            <li>Modern Java (14+) offers "Switch Expressions" with <code>-></code>
                                                syntax which are safer and cleaner.</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/control-if.jsp" ; String
                                            nextLinkUrl=request.getContextPath() + "/tutorials/java/loops-for.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="If-Else Statements" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="For Loops →" />
                                                <jsp:param name="currentLessonId" value="control-switch" />
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