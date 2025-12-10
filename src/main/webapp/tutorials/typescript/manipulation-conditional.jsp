<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "manipulation-conditional" );
        request.setAttribute("currentModule", "Type Manipulation" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width,initial-scale=1.0">
            <title>TypeScript Conditional Types | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: master TypeScript conditional types for type-level logic with extends and infer.">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/manipulation-conditional.jsp">
            <link rel="icon" type="image/svg+xml"
                href="<%=request.getContextPath()%>/tutorials/assets/images/favicon.svg">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/fonts.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/tutorial-server.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/codemirror.min.css">
            <link rel="stylesheet" href="<%=request.getContextPath()%>/tutorials/assets/css/monokai.min.css">
            <script>(function () { var t = localStorage.getItem('tutorial-theme'); if (t === 'dark' || (!t && window.matchMedia('(prefers-color-scheme: dark)').matches)) { document.documentElement.setAttribute('data-theme', 'dark'); } })()</script>
            <%@ include file="../tutorial-ads.jsp" %>
                <%@ include file="../tutorial-analytics.jsp" %>
        
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "LearningResource",
        "name": "TypeScript Conditional Types",
        "description": "Learn conditional types for type-level logic with extends.",
        "learningResourceType": "tutorial",
        "educationalLevel": "Beginner",
        "timeRequired": "PT20M",
        "inLanguage": "en",
        "isAccessibleForFree": true,
        "author": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
        },
        "publisher": {
            "@type": "Organization",
            "name": "8gwifi.org",
            "url": "https://8gwifi.org"
        },
        "datePublished": "2025-12-10",
        "dateModified": "2025-12-10"
    }
    </script>
        </head>

        <body class="tutorial-body no-preview" data-lesson="manipulation-conditional">
            <div class="tutorial-layout">
                <%@ include file="../tutorial-header.jsp" %>
                    <main class="tutorial-main">
                        <%@ include file="../tutorial-sidebar-typescript.jsp" %>
                            <div class="overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>
                            <article class="tutorial-content">
                                <nav class="breadcrumb"><a
                                        href="<%=request.getContextPath()%>/tutorials/">Tutorials</a><span
                                        class="breadcrumb-separator">/</span><a
                                        href="<%=request.getContextPath()%>/tutorials/typescript/">TypeScript</a><span
                                        class="breadcrumb-separator">/</span><span>Conditional Types</span></nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Conditional Types</h1>
                                    <div class="lesson-meta"><span>Advanced</span><span>~22 min</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Conditional types enable type-level if/else logic, allowing types to
                                        change based on conditions.</p>

                                    <h2>Conditional Types</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/manipulation-conditional.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-conditional" />
                                    </jsp:include>

                                    <div class="info-box"><strong>Syntax:</strong> <code>T extends U ? X : Y</code> - if
                                        T extends U, type is X, else Y</div>

                                    <h2>infer Keyword</h2>
                                    <p>The <code>infer</code> keyword extracts types from conditional types:</p>
                                    <pre><code class="language-typescript">type ArrayElement<T> = T extends (infer E)[] ? E : never;
// Extracts element type from array</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Common Use Cases</h2>
                                    <ul>
                                        <li><strong>Type extraction:</strong> Get return types, parameters</li>
                                        <li><strong>Type filtering:</strong> Exclude null/undefined</li>
                                        <li><strong>Type transformation:</strong> Convert based on conditions</li>
                                    </ul>

                                    <div class="tip-box"><strong>Best Practice:</strong> Conditional types power
                                        advanced utility types like ReturnType, Parameters, and NonNullable.</div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Conditional types use <code>T extends U ? X : Y</code></li>
                                            <li><code>infer</code> extracts types in conditions</li>
                                            <li>Enable type-level logic</li>
                                            <li>Foundation of advanced utility types</li>
                                        </ul>
                                    </div>

                                    <h2>What's Next?</h2>
                                    <p>Congratulations! Module 6 complete. You've mastered advanced type manipulation!
                                    </p>

                                    <div style="margin-top:3rem;">
                                        <% String
                                            prevLinkUrl=request.getContextPath()+"/tutorials/typescript/manipulation-mapped.jsp";String
                                            nextLinkUrl=request.getContextPath()+"/tutorials/typescript/modules-es.jsp";%>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Mapped Types" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="ES6 Modules →" />
                                                <jsp:param name="currentLessonId" value="manipulation-conditional" />
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