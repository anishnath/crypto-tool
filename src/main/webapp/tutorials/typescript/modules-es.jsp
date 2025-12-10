<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "modules-es" );
        request.setAttribute("currentModule", "Modules & Real World" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width,initial-scale=1.0">
            <title>TypeScript ES Modules - TypeScript Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: master TypeScript ES modules with import and export for modern JavaScript development.">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/modules-es.jsp">
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
        "name": "TypeScript ES Modules",
        "description": "Learn ES modules with import and export for code organization.",
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

        <body class="tutorial-body no-preview" data-lesson="modules-es">
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
                                        class="breadcrumb-separator">/</span><span>ES Modules</span></nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">ES Modules</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~20 min</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">ES modules provide a standardized way to organize and share code
                                        using import and export statements.</p>

                                    <h2>ES Modules</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/modules-es.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-modules" />
                                    </jsp:include>

                                    <div class="info-box"><strong>Module Types:</strong>
                                        <ul>
                                            <li><strong>Named exports:</strong> <code>export const x = 1;</code></li>
                                            <li><strong>Default export:</strong> <code>export default class {}</code>
                                            </li>
                                            <li><strong>Import:</strong> <code>import { x } from './module';</code></li>
                                        </ul>
                                    </div>

                                    <h2>Export Types</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Type</th>
                                                <th>Export</th>
                                                <th>Import</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Named</td>
                                                <td><code>export const x</code></td>
                                                <td><code>import { x }</code></td>
                                            </tr>
                                            <tr>
                                                <td>Default</td>
                                                <td><code>export default</code></td>
                                                <td><code>import X</code></td>
                                            </tr>
                                            <tr>
                                                <td>All</td>
                                                <td><code>export *</code></td>
                                                <td><code>import * as X</code></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <div class="tip-box"><strong>Best Practice:</strong> Use named exports for
                                        utilities, default export for main class/component.</div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>ES modules use import/export</li>
                                            <li>Named exports for multiple items</li>
                                            <li>Default export for main export</li>
                                            <li>Standard module system</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top:3rem;">
                                        <% String
                                            prevLinkUrl=request.getContextPath()+"/tutorials/typescript/manipulation-conditional.jsp";String
                                            nextLinkUrl=request.getContextPath()+"/tutorials/typescript/modules-namespaces.jsp";%>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Conditional Types" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Namespaces →" />
                                                <jsp:param name="currentLessonId" value="modules-es" />
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