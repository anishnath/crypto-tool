<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "manipulation-keyof" );
        request.setAttribute("currentModule", "Type Manipulation" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width,initial-scale=1.0">
            <title>TypeScript keyof Operator - TypeScript Tutorial | 8gwifi.org</title>
            <meta name="description" content="Free TypeScript tutorial: master TypeScript keyof operator for creating unions of object keys.">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/manipulation-keyof.jsp">
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
        "name": "TypeScript keyof Operator",
        "description": "Learn the keyof operator to extract object property keys.",
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

        <body class="tutorial-body no-preview" data-lesson="manipulation-keyof">
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
                                        class="breadcrumb-separator">/</span><span>keyof Operator</span></nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">keyof Operator</h1>
                                    <div class="lesson-meta"><span>Advanced</span><span>~18 min</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">The keyof operator creates a union type of all property keys in an
                                        object type, enabling type-safe property access.</p>

                                    <h2>keyof Operator</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/manipulation-keyof.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-keyof" />
                                    </jsp:include>

                                    <div class="info-box"><strong>keyof Syntax:</strong> <code>keyof T</code> creates a
                                        union of all keys in type T</div>

                                    <h2>Common Use Cases</h2>
                                    <ul>
                                        <li><strong>Type-safe property access:</strong> Ensure keys exist</li>
                                        <li><strong>Generic constraints:</strong> Limit to valid keys</li>
                                        <li><strong>Mapped types:</strong> Transform object types</li>
                                        <li><strong>Utility functions:</strong> Object manipulation</li>
                                    </ul>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Common Mistakes</h2>
                                    <div class="mistake-box">
                                        <h4>1. Using String Instead of keyof</h4>
                                        <pre><code class="language-typescript">// ✗ Wrong - allows any string
function get<T>(obj: T, key: string) {
    return obj[key];  // Unsafe!
}

// ✓ Correct - only valid keys
function get<T, K extends keyof T>(obj: T, key: K) {
    return obj[key];  // Type-safe!
}</code></pre>
                                    </div>

                                    <div class="tip-box"><strong>Best Practice:</strong> Use <code>keyof</code> with
                                        generics for type-safe property access.</div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li><code>keyof T</code> creates union of all keys</li>
                                            <li>Perfect for type-safe property access</li>
                                            <li>Combine with generics for flexibility</li>
                                            <li>Essential for mapped types</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top:3rem;">
                                        <% String
                                            prevLinkUrl=request.getContextPath()+"/tutorials/typescript/utility-record.jsp";String
                                            nextLinkUrl=request.getContextPath()+"/tutorials/typescript/manipulation-typeof.jsp";%>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Record & Readonly" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="typeof Operator →" />
                                                <jsp:param name="currentLessonId" value="manipulation-keyof" />
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