<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <% request.setAttribute("currentLesson", "advanced-union" ); request.setAttribute("currentModule", "Advanced Types"
        ); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>TypeScript Union Types - TypeScript Tutorial | 8gwifi.org</title>
            <meta name="description"
                content="Free TypeScript tutorial: master TypeScript union types for flexible type definitions with OR logic.">
            <link rel="canonical" href="https://8gwifi.org/tutorials/typescript/advanced-union.jsp">
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
        "name": "TypeScript Union Types",
        "description": "Master union types for flexible type definitions with OR logic and type narrowing.",
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

        <body class="tutorial-body no-preview" data-lesson="advanced-union">
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
                                        class="breadcrumb-separator">/</span><span>Union Types</span></nav>
                                <header class="lesson-header">
                                    <h1 class="lesson-title">Union Types</h1>
                                    <div class="lesson-meta"><span>Intermediate</span><span>~20 min</span></div>
                                </header>
                                <jsp:include page="../tutorial-ad-slot.jsp">
                                    <jsp:param name="slot" value="top" />
                                </jsp:include>
                                <div class="lesson-body">
                                    <p class="lead">Union types allow a value to be one of several types using OR logic.
                                        They provide flexibility while maintaining type safety.</p>

                                    <img src="<%=request.getContextPath()%>/tutorials/assets/images/ts-union-types.svg"
                                        alt="TypeScript Union Types" class="diagram-image"
                                        style="max-width: 800px; margin: 2rem auto; display: block;">

                                    <h2>Basic Union Types</h2>
                                    <jsp:include page="../tutorial-compiler.jsp">
                                        <jsp:param name="codeFile" value="typescript/advanced-union.ts" />
                                        <jsp:param name="language" value="typescript" />
                                        <jsp:param name="editorId" value="compiler-union" />
                                    </jsp:include>

                                    <div class="info-box"><strong>Union Type Syntax:</strong> Use the pipe symbol
                                        <code>|</code> to combine types: <code>type A = string | number</code></div>

                                    <h2>When to Use Union Types</h2>
                                    <ul>
                                        <li><strong>Flexible IDs:</strong> Accept both string and number IDs</li>
                                        <li><strong>Status values:</strong> Limited set of string literals</li>
                                        <li><strong>Optional data:</strong> Value or null/undefined</li>
                                        <li><strong>API responses:</strong> Success data or error</li>
                                    </ul>

                                    <jsp:include page="../tutorial-ad-slot.jsp">
                                        <jsp:param name="slot" value="middle" />
                                    </jsp:include>

                                    <h2>Type Narrowing</h2>
                                    <p>Use type guards to narrow union types:</p>
                                    <pre><code class="language-typescript">function process(value: string | number) {
    if (typeof value === "string") {
        // TypeScript knows it's a string here
        console.log(value.toUpperCase());
    } else {
        // TypeScript knows it's a number here
        console.log(value.toFixed(2));
    }
}</code></pre>

                                    <h2>Common Mistakes</h2>
                                    <div class="mistake-box">
                                        <h4>1. Accessing Properties Without Narrowing</h4>
                                        <pre><code class="language-typescript">type Result = { success: true; data: string } | { success: false; error: string };

function handle(result: Result) {
    console.log(result.data);  // ✗ Error! 'data' doesn't exist on both types
}

// ✓ Correct - narrow the type first
function handle(result: Result) {
    if (result.success) {
        console.log(result.data);  // ✓ OK
    } else {
        console.log(result.error);  // ✓ OK
    }
}</code></pre>

                                        <h4>2. Too Many Union Members</h4>
                                        <pre><code class="language-typescript">// ✗ Hard to maintain
type Data = string | number | boolean | null | undefined | object | any[];

// ✓ Better - use more specific types
type StringOrNumber = string | number;
type Nullable<T> = T | null;</code></pre>
                                    </div>

                                    <div class="tip-box"><strong>Best Practice:</strong> Keep unions simple (2-4 types).
                                        For complex scenarios, consider discriminated unions.</div>

                                    <h2>Summary</h2>
                                    <div class="summary-box">
                                        <ul>
                                            <li>Union types use <code>|</code> for OR logic</li>
                                            <li>Value can be ANY of the specified types</li>
                                            <li>Use type guards to narrow types</li>
                                            <li>Perfect for flexible function parameters</li>
                                        </ul>
                                    </div>

                                    <div style="margin-top:3rem;">
                                        <% String
                                            prevLinkUrl=request.getContextPath()+"/tutorials/typescript/classes-static.jsp";String
                                            nextLinkUrl=request.getContextPath()+"/tutorials/typescript/advanced-intersection.jsp";%>
                                            <jsp:include page="../tutorial-nav.jsp">
                                                <jsp:param name="prevLink" value="<%=prevLinkUrl%>" />
                                                <jsp:param name="prevTitle" value="← Static Members" />
                                                <jsp:param name="nextLink" value="<%=nextLinkUrl%>" />
                                                <jsp:param name="nextTitle" value="Intersection Types →" />
                                                <jsp:param name="currentLessonId" value="advanced-union" />
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