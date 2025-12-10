<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "types-enums" );
        request.setAttribute("currentModule", "Getting Started & Basic Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <title>TypeScript Enums - TypeScript Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: master TypeScript enums: numeric enums, string enums, const enums, and heterogeneous enums. Learn when and how to use enums effecti...">
            <meta name="keywords"
                content="typescript enums, numeric enums, string enums, const enums, typescript constants">
            <meta property="og:type" content="article">
            <meta property="og:title" content="TypeScript Enums - TypeScript Tutorial | 8gwifi.org">
            <meta property="og:description" content="Learn TypeScript enums with interactive examples.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/types-enums.jsp">
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
        "name": "TypeScript Enums",
        "description": "Learn TypeScript enums for defining named constants.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["numeric enums", "string enums", "const enums"],
        "timeRequired": "PT15M",
        "isPartOf": {
            "@type": "Course",
            "name": "TypeScript Tutorial",
            "url": "https://8gwifi.org/tutorials/typescript/"
        }
    }
    </script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        </head>

        <body class="tutorial-body no-preview" data-lesson="types-enums">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>
                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-typescript.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
                            <article class="tutorial-content">
                                <nav class="breadcrumb">
                                    <a href="<%=request.getContextPath()%>/tutorials/">Tutorials</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <a href="<%=request.getContextPath()%>/tutorials/typescript/">TypeScript</a>
                                    <span class="breadcrumb-separator">/</span>
                                    <span>Enums</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">TypeScript Enums</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~15 min read</span>
                                    </div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Enums (enumerations) allow you to define a set of named constants.
                                        They make code more readable and maintainable by giving meaningful names to
                                        numeric or string values.</p>

                                    <h2>Numeric Enums</h2>
                                    <p>Numeric enums auto-increment from 0 by default:</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/types-enums-numeric.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-numeric" />
                                    </jsp:include>

                                    <h2>String Enums</h2>
                                    <p>String enums use string values instead of numbers:</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/types-enums-string.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-string" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Const Enums</h2>
                                    <p>Const enums are completely removed during compilation for better performance:</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/types-enums-const.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-const" />
                                    </jsp:include>

                                    <h2>Exercise: Status System</h2>
                                    <div class="exercise-section">
                                        <p><strong>Task:</strong> Create an order status system using enums!</p>
                                        <jsp:include page="../tutorial-compiler.jsp">
                                            <jsp:param name="codeFile" value="typescript/exercises/ex-enums.ts" />
                                            <jsp:param name="language" value="typescript" />
                                            <jsp:param name="editorId" value="exercise-enums" />
                                        </jsp:include>
                                    </div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Numeric enums auto-increment from 0</li>
                                            <li>String enums use explicit string values</li>
                                            <li>Const enums are inlined at compile time</li>
                                            <li>Enums improve code readability</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Next, we'll explore <strong>Special Types</strong> like any, unknown, void, and
                                        never!</p>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/typescript/types-arrays.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/typescript/types-special.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Arrays & Tuples" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Special Types →" />
                                                <jsp:param name="currentLessonId" value="types-enums" />
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
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/codemirror-modes/javascript.min.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/progress.js"></script>
            <script src="<%=request.getContextPath()%>/tutorials/assets/js/tutorial-core.js?v=4"></script>
        </body>

        </html>