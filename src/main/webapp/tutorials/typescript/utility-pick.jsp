<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "utility-pick" );
        request.setAttribute("currentModule", "Generics & Utility Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width,initial-scale=1.0">
            <title>TypeScript Pick & Omit - TypeScript Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: master TypeScript Pick and Omit utility types for selecting or excluding properties.">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/utility-pick.jsp">
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
        "name": "TypeScript Pick & Omit",
        "description": "Master Pick and Omit utilities to select object properties.",
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
        "isPartOf": {
            "@type": "Course",
            "name": "TypeScript Tutorial",
            "url": "https://8gwifi.org/tutorials/typescript/"
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

        <body class="tutorial-body no-preview" data-lesson="utility-pick">
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
                                        class="breadcrumb-separator">/</span><span>Pick & Omit</span></nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Pick & Omit</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~18 min</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Pick and Omit utility types create new types by selecting or
                                        excluding specific properties from existing types.</p>

                                    <h2>Pick & Omit Types</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/utility-pick.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-pick" />
                                    </jsp:include>

                                    <div class="info-box"><strong>Utility Types:</strong>
                                        <ul>
                                            <li><code>Pick&lt;T, K&gt;</code> - Select specific properties</li>
                                            <li><code>Omit&lt;T, K&gt;</code> - Exclude specific properties</li>
                                        </ul>
                                    </div>

                                    <h2>Pick vs Omit</h2>
                                    <table class="info-table">
                                        <thead>
                                            <tr>
                                                <th>Utility</th>
                                                <th>Action</th>
                                                <th>Use When</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Pick</td>
                                                <td>Include only specified</td>
                                                <td>Few properties needed</td>
                                            </tr>
                                            <tr>
                                                <td>Omit</td>
                                                <td>Exclude specified</td>
                                                <td>Most properties needed</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Common Mistakes</h2>
                                    <div class="mistake-box">
                                        <h4>1. Wrong Property Names</h4>
                                        <pre><code class="language-typescript">interface User {
    id: number;
    userName: string;
}

// ✗ Error - 'name' doesn't exist
type UserPreview = Pick<User, "id" | "name">;

// ✓ Correct
type UserPreview = Pick<User, "id" | "userName">;</code></pre>
                                    </div>

                                    <div class="tip-box"><strong>Best Practice:</strong> Use <code>Pick</code> when you
                                        need few properties, <code>Omit</code> when excluding few.</div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><code>Pick&lt;T, K&gt;</code> selects specific properties</li>
                                            <li><code>Omit&lt;T, K&gt;</code> excludes specific properties</li>
                                            <li>Perfect for creating focused types</li>
                                            <li>Type-safe property selection</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top:3rem;">
                                        <% String
                                            prevLinkUrl=request.getContextPath()+"/tutorials/typescript/utility-partial.jsp";String
                                            nextLinkUrl=request.getContextPath()+"/tutorials/typescript/utility-record.jsp";%>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Partial & Required" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Record & Readonly →" />
                                                <jsp:param name="currentLessonId" value="utility-pick" />
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