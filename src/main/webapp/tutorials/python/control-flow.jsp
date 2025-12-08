<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "control-flow" ); request.setAttribute("currentModule", "Introduction" );
        %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Control Flow - Python Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Master Python control flow statements: if, elif, else, for loops, and while loops.">
            <meta name="keywords"
                content="python control flow, python if else, python loops, python for loop, python while loop">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Control Flow - Python Tutorial">
            <meta property="og:description" content="Master Python control flow statements.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

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
        "name": "Python Control Flow",
        "description": "Learn about if statements and loops in Python.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
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

        <body class="tutorial-body no-preview" data-lesson="control-flow">
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
                                    <span>Control Flow</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Control Flow</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~12 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                    <jsp:param name="responsive" value="true" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <h2>If...Else Statements</h2>
                                    <p>Python supports the usual logical conditions from mathematics. These can be used
                                        in <code>if</code> statements.</p>
                                    <p><strong>Note:</strong> Python uses <strong>indentation</strong> (whitespace) to
                                        define scope, instead of curly brackets.</p>

                                    <div class="code-block">
                                        <pre><code class="language-python">a = 33
b = 200
if b > a:
    print("b is greater than a")
elif a == b:
    print("a and b are equal")
else:
    print("a is greater than b")</code></pre>
                                    </div>

                                    <h2>Loops</h2>
                                    <h3>While Loop</h3>
                                    <p>With the <code>while</code> loop we can execute a set of statements as long as a
                                        condition is true.</p>

                                    <h3>For Loop</h3>
                                    <p>A <code>for</code> loop is used for iterating over a sequence (like a list,
                                        tuple, dictionary, set, or string).</p>

                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="python/control-flow-basics.py" />
                                        <jsp:param name="language" value="python" />
                                        <jsp:param name="editorId" value="compiler-flow" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                        <jsp:param name="responsive" value="true" />
                                    </jsp:include>

                                    <h2>Range Function</h2>
                                    <p>To loop through a set of code a specified number of times, we can use the
                                        <code>range()</code> function.
                                    </p>
                                    <ul>
                                        <li><code>range(6)</code> generates 0 to 5.</li>
                                        <li><code>range(2, 6)</code> generates 2 to 5.</li>
                                        <li><code>range(2, 30, 3)</code> generates 2, 5, 8, ... (step 3).</li>
                                    </ul>
                                </div>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="bottom" />
                                    <jsp:param name="responsive" value="true" />
                                </jsp:include>

                                <jsp:include page="../tutorial-nav.jsp">
                                    <jsp:param name="prevLink" value="operators-membership.jsp" />
                                    <jsp:param name="prevTitle" value="Membership Operators" />
                                    <jsp:param name="nextLink" value="index.jsp" />
                                    <jsp:param name="nextTitle" value="Course Overview" />
                                    <jsp:param name="currentLessonId" value="control-flow" />
                                </jsp:include>
                            </article>
                    </main>

                    <%@ include file="../tutorial-footer.jsp" %>
            </div>

            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/xml.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/htmlmixed.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/css.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/python.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>