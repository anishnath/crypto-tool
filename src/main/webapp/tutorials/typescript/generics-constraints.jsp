<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "generics-constraints" );
        request.setAttribute("currentModule", "Generics & Utility Types" ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width,initial-scale=1.0">
            <title>TypeScript Generic Constraints | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: master TypeScript generic constraints to limit type parameters with extends and keyof.">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/generics-constraints.jsp">
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
        "name": "TypeScript Generic Constraints",
        "description": "Learn generic constraints with extends and keyof operators.",
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

        <body class="tutorial-body no-preview" data-lesson="generics-constraints">
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
                                        class="breadcrumb-separator">/</span><span>Generic Constraints</span></nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Generic Constraints</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~22 min</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Generic constraints limit type parameters to specific types using
                                        extends, ensuring type safety while maintaining flexibility.</p>

                                    <h2>Constraints with Extends</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/generics-constraints.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-constraints" />
                                    </jsp:include>

                                    <div class="info-box"><strong>Constraint Syntax:</strong> Use
                                        <code>&lt;T extends Type&gt;</code> to constrain T to types that extend or
                                        implement Type.</div>

                                    <h2>keyof Constraint</h2>
                                    <p>The <code>keyof</code> operator creates a union of all property keys:</p>
                                    <pre><code class="language-typescript">function getValue<T, K extends keyof T>(obj: T, key: K): T[K] {
    return obj[key];  // Type-safe property access
}</code></pre>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Common Mistakes</h2>
                                    <div class="mistake-box">
                                        <h4>1. No Constraint When Needed</h4>
                                        <pre><code class="language-typescript">// ✗ Error - T might not have length
function logLength<T>(item: T) {
    console.log(item.length);  // Error!
}

// ✓ Correct - constrain to types with length
function logLength<T extends { length: number }>(item: T) {
    console.log(item.length);  // ✓ OK
}</code></pre>

                                        <h4>2. Wrong keyof Usage</h4>
                                        <pre><code class="language-typescript">// ✗ Wrong - allows any string
function get<T>(obj: T, key: string) {
    return obj[key];  // Unsafe!
}

// ✓ Correct - only valid keys
function get<T, K extends keyof T>(obj: T, key: K) {
    return obj[key];  // Type-safe!
}</code></pre>
                                    </div>

                                    <div class="tip-box"><strong>Best Practice:</strong> Use constraints to ensure
                                        generic types have required properties or methods.</div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Constraints limit type parameters with <code>extends</code></li>
                                            <li><code>keyof</code> creates union of property keys</li>
                                            <li>Ensures type safety while maintaining flexibility</li>
                                            <li>Perfect for property access and object manipulation</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top:3rem;">
                                        <% String
                                            prevLinkUrl=request.getContextPath()+"/tutorials/typescript/generics-functions.jsp";String
                                            nextLinkUrl=request.getContextPath()+"/tutorials/typescript/utility-partial.jsp";%>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Generic Functions" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Partial & Required →" />
                                                <jsp:param name="currentLessonId" value="generics-constraints" />
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