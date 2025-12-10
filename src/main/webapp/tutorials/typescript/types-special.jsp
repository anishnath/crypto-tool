<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "types-special" );
        request.setAttribute("currentModule", "Getting Started & Basic Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <title>TypeScript Special Types | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: master TypeScript special types: any, unknown, void, never, null, and undefined. Learn when to use each type and best practices.">
            <meta name="keywords"
                content="typescript any, typescript unknown, typescript void, typescript never, typescript null, typescript undefined">
            <meta property="og:type" content="article">
            <meta property="og:title" content="TypeScript Special Types - TypeScript Tutorial | 8gwifi.org">
            <meta property="og:description" content="Learn TypeScript special types with interactive examples.">
            <meta property="og:site_name" content="8gwifi.org Tutorials">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/types-special.jsp">
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
        "name": "TypeScript Special Types",
        "description": "Learn TypeScript special types: any, unknown, void, never.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "teaches": ["any type", "unknown type", "void type", "never type"],
        "timeRequired": "PT18M",
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

        <body class="tutorial-body no-preview" data-lesson="types-special">
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
                                    <span>Special Types</span>
                                </nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Special Types</h1>
                                    <div class="lesson-meta">
                                        <span>Beginner</span>
                                        <span>~18 min read</span>
                                    </div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">TypeScript has several special types that handle edge cases and
                                        specific scenarios: <code>any</code>, <code>unknown</code>, <code>void</code>,
                                        <code>never</code>, <code>null</code>, and <code>undefined</code>.</p>

                                    <h2>The any Type</h2>
                                    <p>The <code>any</code> type disables type checking - use sparingly!</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/types-any.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-any" />
                                    </jsp:include>

                                    <h2>The unknown Type</h2>
                                    <p>The <code>unknown</code> type is type-safe alternative to <code>any</code>:</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/types-unknown.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-unknown" />
                                    </jsp:include>

                                    <h2>The void Type</h2>
                                    <p>The <code>void</code> type means "no return value":</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/types-void.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-void" />
                                    </jsp:include>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>The never Type</h2>
                                    <p>The <code>never</code> type represents values that never occur:</p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/types-never.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-never" />
                                    </jsp:include>

                                    <h2>null and undefined</h2>
                                    <p>TypeScript has separate types for <code>null</code> and <code>undefined</code>:
                                    </p>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/types-null-undefined.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-null" />
                                    </jsp:include>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><code>any</code> - Disables type checking (use sparingly)</li>
                                            <li><code>unknown</code> - Type-safe version of any</li>
                                            <li><code>void</code> - No return value</li>
                                            <li><code>never</code> - Values that never occur</li>
                                            <li><code>null</code> and <code>undefined</code> - Absence of value</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Congratulations! You've completed Module 1. Next, we'll dive into
                                        <strong>Functions & Interfaces</strong> in Module 2!</p>

                                    <div style="margin-top: 3rem;">
                                        <% String prevLinkUrl=request.getContextPath()
                                            + "/tutorials/typescript/types-enums.jsp" ; String
                                            nextLinkUrl=request.getContextPath()
                                            + "/tutorials/typescript/functions-basics.jsp" ; %>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Enums" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Function Types →" />
                                                <jsp:param name="currentLessonId" value="types-special" />
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