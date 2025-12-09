<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "oop-access-modifiers" );
        request.setAttribute("currentModule", "OOP Basics" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <title>Java Access Modifiers - Java Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Learn about Java Access Modifiers: public, private, protected, and default. Control visibility of classes, fields, and methods.">
            <meta name="keywords"
                content="java access modifiers, java public private protected, java visibility, encapsulation java">

            <meta property="og:type" content="article">
            <meta property="og:title" content="Java Access Modifiers - Java Tutorial | 8gwifi.org">
            <meta property="og:description" content="Control code visibility and encapsulation with Access Modifiers.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">

            <link rel="canonical" href="https://8gwifi.org/tutorials/java/oop-access-modifiers.jsp">
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
    "name": "Java Access Modifiers",
    "description": "Guide to Java access modifiers.",
    "learningResourceType": "tutorial",
    "educationalLevel": "Intermediate",
    "teaches": ["Public", "Private", "Protected", "Default Access"],
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

        <body class="tutorial-body no-preview" data-lesson="oop-access-modifiers">
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
                                    <span>Access Modifiers</span>
                                </nav>

                                <header class="lesson-header">
                                    <h1 class="lesson-title">Access Modifiers</h1>
                                    <div class="lesson-meta">
                                        <span>Intermediate</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>

                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>

                                <div class="lesson-body">
                                    <p class="lead"><strong>Access Modifiers</strong> determine the visibility
                                        (accessibility) of classes, constructors, fields, and methods in Java.</p>

                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Modifier</th>
                                                <th>Class</th>
                                                <th>Package</th>
                                                <th>Subclass</th>
                                                <th>World</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>public</code></td>
                                                <td>Yes</td>
                                                <td>Yes</td>
                                                <td>Yes</td>
                                                <td>Yes</td>
                                            </tr>
                                            <tr>
                                                <td><code>protected</code></td>
                                                <td>Yes</td>
                                                <td>Yes</td>
                                                <td>Yes</td>
                                                <td>No</td>
                                            </tr>
                                            <tr>
                                                <td>default (no modifier)</td>
                                                <td>Yes</td>
                                                <td>Yes</td>
                                                <td>No</td>
                                                <td>No</td>
                                            </tr>
                                            <tr>
                                                <td><code>private</code></td>
                                                <td>Yes</td>
                                                <td>No</td>
                                                <td>No</td>
                                                <td>No</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <h2>Why use them?</h2>
                                    <p>To achieve <strong>Encapsulation</strong>. You should generally make fields
                                        <code>private</code> and provide <code>public</code> methods (getters/setters)
                                        to access them.</p>

                                    <!-- Example -->
                                    <h2>Full Example</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="java/oop-access-modifiers.java" />
                                        <jsp:param name="language" value="java" />
                                        <jsp:param name="editorId" value="compiler-access" />
                                    </jsp:include>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/java/oop-methods.jsp" ; String
                                            nextLinkUrl=request.getContextPath() + "/tutorials/java/oop-static.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="Methods in Classes" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Static Members →" />
                                                <jsp:param name="currentLessonId" value="oop-access-modifiers" />
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